require 'octokit'
require 'json'

##############################
# Config
##############################

# dry run?
DRY_RUN = false

# delete existing labels which are not specified?
DELETE_MISSING = true

# skip labels which exist already
SKIP_EXISTING = false

# labels file
LABELS_FILE = 'labels.json'

# ignore case when matching existing labels?
CASE_INSENSITIVE = true

# Github login creds
GITHUB_LOGIN = "gh_user"
GITHUB_PASSWORD = "gh_password"

# or set this instead
GITHUB_API_KEY = 'api_key'

# Specify the github project
GITHUB_REPOSITORY = "User/repo"

##############################
# End Config
##############################

@client
@new_labels
@existing_labels

# Log into Github
def init_client()
  @client = if GITHUB_API_KEY
    Octokit::Client.new(:access_token => GITHUB_API_KEY)
  else
    Octokit::Client.new(:login => GITHUB_LOGIN, :password => GITHUB_PASSWORD)
  end
end

def cased_label(label)
  if CASE_INSENSITIVE == true
    label.downcase
  else
    label
  end
end

def get_new_labels()
  file = File.read(LABELS_FILE)
  @new_labels = {}

  for name, color in JSON.parse(file) do
    cased_name = cased_label(name)

    @new_labels[cased_name] = {
      :name => name,
      :color => color,
    }
  end
end

def get_existing_labels()
  @existing_labels = {}

  @client.labels(GITHUB_REPOSITORY).each{|label|
    name = cased_label(label[:name])
    @existing_labels[name] = label
  }

  return nil
end

def create_label(name, color)
  puts "create label #{name}"
  if DRY_RUN == true then return end

  @client.add_label(GITHUB_REPOSITORY, name, color)
end

def update_label(real_name, new_name, new_color)
  puts "update label #{real_name}"
  if DRY_RUN == true then return end

  @client.update_label(GITHUB_REPOSITORY, real_name, {
    :name => new_name,
    :color => new_color,
  })
end

def update_labels()
  for cased_name, new_label in @new_labels do
    new_name = new_label[:name]
    new_color = new_label[:color]

    existing = @existing_labels[cased_name]

    # create new
    if existing.nil?
      create_label(new_name, new_color)

    # present, but we should skip it
    elsif SKIP_EXISTING == true

    # modify existing
    else
      existing_color = existing[:color]
      existing_name = existing[:name]

      if new_name != existing_name or new_color != existing_color
        update_label(existing_name, new_name, new_color)
      end
    end
  end
end

def remove_labels()
  unless DELETE_MISSING == true then return end

  for cased_name, label in @existing_labels do
    new_label = @new_labels[cased_name]

    # delete it
    if new_label.nil?
      puts "delete label #{cased_name}"
      if DRY_RUN then next end

      @client.delete_label!(GITHUB_REPOSITORY, label[:name])
    end
  end
end



# All together now.
init_client()
get_new_labels()
get_existing_labels()
update_labels()
remove_labels()

puts "\nFinished updating labls in repository '#{GITHUB_REPOSITORY}'!"
