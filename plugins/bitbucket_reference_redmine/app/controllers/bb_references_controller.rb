# Copyright (C) 2017  Productize
#
# License: see LICENSE file

class BbReferencesController < ApplicationController
  unloadable
  skip_before_action :check_if_login_required, :verify_authenticity_token
  before_action :check_new_bb_account_allowed, :only => [:descriptor, :installed]
  before_action :check_jwt, :except => [:descriptor, :installed]

  def descriptor
    @connect_descriptor = {
      "key"=> "bitbucket-reference-redmine",
      "name"=> "Reference Redmine",
      "description"=> "Reference Redmine issues in Bitbucket",
      "vendor"=> {
        "name"=> "Productize",
        "url"=> "https://productize.be"
      },
      "baseUrl"=> request.base_url,
      "authentication"=> {
        "type"=> "jwt"
      },
      "lifecycle"=> {
        "installed"=> "/bitbucket-references/installed",
        "uninstalled"=> "/bitbucket-references/uninstalled"
      },
      "scopes"=> ["account", "account:write"],
      "modules"=> {
        "postInstallRedirect"=> {
          "key"=> "redirect",
          "url"=> "settings/plugin/bitbucket_reference_redmine"
        },
        "linkers"=> [
          {
            "key"=> "redmine-url-linker",
            "regex"=> "(?<!&)#([0-9]+)",
            "url"=> "/issues/\\1",
            "type"=> "href"
          }
        ],
        "webhooks"=> [
          {
            "event"=> "repo:push",
            "url"=> "/bitbucket-references/push"
          }, {
            "event"=> "repo:commit_comment_created",
            "url"=> "/bitbucket-references/commit_comment"
          }, {
            "event"=> "pullrequest:created",
            "url"=> "/bitbucket-references/pullrequest"
          }, {
            "event"=> "pullrequest:comment_created",
            "url"=> "/bitbucket-references/pullrequest_comment"
          }
        ]
      }
  }
  end

  def installed
    if params["productType"] != "bitbucket"
      render_error({
        :message => "Sorry, this add-on only works with Bitbucket",
        :status => 400
      })
      return false
    end

    bb_connection = BitbucketConnection.create(
      client_key:     params["clientKey"],
      shared_secret:  params["sharedSecret"],
      base_api_url:   params["baseApiUrl"],
      user:           params["user"]["display_name"],
      user_link:      params["user"]["links"]["html"]["href"],
      principal:      params["principal"]["display_name"],
      principal_link: params["principal"]["links"]["html"]["href"],
    )

    Setting.plugin_bitbucket_reference_redmine["allow_new_bb_accounts"] = "0"
    render json: "Connection made successfully"
  end

  def uninstalled
    bb_connection = BitbucketConnection.find_by!(
      client_key: params["clientKey"]
    )
    raise ActiveRecord::RecordNotFound if bb_connection.nil?

    bb_connection.destroy
    render json: "bye"
  end

  def push
    repo    = params["data"]["repository"]
    changes = params["data"]["push"]["changes"]

    journals = []
    changes.each do |change|
      change["commits"].each do |commit|
        issues = get_referenced_issues(/(?<!&)#([0-9]+)/, commit["message"])
        author = commit["author"].key?("user")?
          link(
            commit["author"]["user"]["display_name"],
            commit["author"]["user"]["links"]["html"]["href"]
          ):
          CGI.escapeHTML(commit["author"]["raw"])

        note = "Referenced by %s in %s of %s\n%s" % [
          author,
          link(commit["hash"][0,7], commit["links"]["html"]["href"]),
          link(repo["full_name"], repo["links"]["html"]["href"]),
          blockquote(commit["message"])
        ]
        issues.each do |issue|
          # Check if a journal entry was already made for this issue with the same note
          if Journal.select(:id).where(:journalized_id => issue.id, :notes => note).count == 0
            journals << Journal.new(
              :journalized => issue,
              :user        => user(),
              :created_on  => commit["date"],
              :notes       => note
            )
          end
        end
      end
    end

    Journal.transaction do
      journals.each(&:save!)
    end

    render json: "thanks"
  end

  def commit_comment
    comment = params["data"]["comment"]
    actor   = params["data"]["actor"]
    commit  = params["data"]["commit"]
    repo    = params["data"]["repository"]

    content = comment["content"]["raw"]

    issues = get_referenced_issues(/(?<!&)#([0-9]+)/, content)

    note = "Referenced by %s in %s of %s\n%s" % [
      link(actor["display_name"], actor["links"]["html"]["href"]),
      link("a comment on "+commit["hash"][0,7], comment["links"]["html"]["href"]),
      link(repo["full_name"], repo["links"]["html"]["href"]),
      blockquote(content)
    ]

    journals = []
    issues.each do |issue|
      journals << Journal.new(
        :journalized => issue,
        :user        => user(),
        :created_on  => comment["created_on"],
        :notes       => note
      )
    end

    Journal.transaction do
      journals.each(&:save!)
    end

    render json: "thanks"
  end

  def pullrequest
    actor = params["data"]["actor"]
    pr    = params["data"]["pullrequest"]
    repo  = params["data"]["repository"]

    regex = /(?<!&)#([0-9]+)/

    issues = get_referenced_issues(regex, pr["title"])
    issues.concat get_referenced_issues(regex, pr["description"])

    note = "Referenced by %s in %s of %s\n%s" % [
      link(actor["display_name"], actor["links"]["html"]["href"]),
      link("pull request "+pr["id"].to_s, pr["links"]["html"]["href"]),
      link(repo["full_name"], repo["links"]["html"]["href"]),
      blockquote(title(pr["title"])+"\n\n"+pr["description"])
    ]

    journals = []
    issues.each do |issue|
      journals << Journal.new(
        :journalized => issue,
        :user        => user(),
        :created_on  => pr["created_on"],
        :notes       => note
      )
    end

    Journal.transaction do
      journals.each(&:save!)
    end

    render json: "thanks"
  end

  def pullrequest_comment
    pr      = params["data"]["pullrequest"]
    repo    = params["data"]["repository"]
    comment = params["data"]["comment"]

    content = comment["content"]["raw"]
    user    = comment["user"]

    issues = get_referenced_issues(/(?<!&)#([0-9]+)/, content)

    note = "Referenced by %s in %s on %s of %s\n%s" % [
      link(user["display_name"], user["links"]["html"]["href"]),
      link("a comment", comment["links"]["html"]["href"]),
      link("pull request "+pr["id"].to_s, pr["links"]["html"]["href"]),
      link(repo["full_name"], repo["links"]["html"]["href"]),
      blockquote(content)
    ]

    journals = []
    issues.each do |issue|
      journals << Journal.new(
        :journalized => issue,
        :user        => user(),
        :created_on  => comment["created_on"],
        :notes       => note
      )
    end

    Journal.transaction do
      journals.each(&:save!)
    end

    render json: "thanks"
  end

  private

  def user
    return User.find_by_login!("bitbucket_reference_redmine")
  end

  def link(text, url)
    case Setting.text_formatting
    when 'markdown'
      return "[%s](%s)" % [text, url]
    when 'textile'
      return "\"%s\":%s" % [text, url]
    else
      return text
    end
  end

  def blockquote(text)
    return text.gsub(/^/, '>')
  end

  def title(text)
    # Using bold because a header looks crappy
    case Setting.text_formatting
    when 'markdown'
      return "**"+text+"**"
    when 'textile'
      return "*"+text+"*"
    else
      return text
    end
  end

  def check_new_bb_account_allowed
    if Setting.plugin_bitbucket_reference_redmine["allow_new_bb_accounts"] != "1"
      render_404
      return false
    end
  end

  def check_jwt
    raise Unauthorized unless request.headers.key?("HTTP_AUTHORIZATION")
    auth_type, token = request.headers["HTTP_AUTHORIZATION"].split
    raise Unauthorized unless auth_type == "JWT"

    begin
      payload, _ = JWT.decode token, nil, false
      bb_connection = BitbucketConnection.find_by!(
        client_key: payload["iss"],
        allowed: true
      )
      raise Unauthorized if bb_connection.nil?

      JWT.decode token, bb_connection.shared_secret, true
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      raise Unauthorized
    end
  end

  def get_referenced_issues(regex, text)
    referenced_ids = []
    text.scan(regex).each do |groups|
      issue_id = groups[0]
      if !referenced_ids.include? issue_id
        referenced_ids << issue_id
      end
    end

    return Issue.joins(:project).where({
      :id => (referenced_ids),
      projects: { status: Project::STATUS_ACTIVE }
    }).to_a
  end

end
