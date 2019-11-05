##############################
# Environment Based Config
##############################

def as_boolean(input, default)
  input = (input || '').downcase.strip

  if input == 'true'
    return true
  end

  if input == 'false'
    return false
  end

  return default
end


# dry run?
DRY_RUN = as_boolean(ENV['DRY_RUN'], true)

# delete existing labels which are not specified?
DELETE_MISSING = as_boolean(ENV['DELETE_MISSING'], false)

# skip labels which exist already
SKIP_EXISTING = as_boolean(ENV['SKIP_EXISTING'], true)

# labels file
LABELS_FILE = ENV['LABELS_FILE'] || 'labels.json'

# Specify the github project
GITHUB_REPOSITORY = ENV['GITHUB_REPO']

# Github login creds
GITHUB_LOGIN = ENV['GITHUB_LOGIN']
GITHUB_PASSWORD = ENV['GITHUB_PASSWORD']

# or set this instead
GITHUB_API_KEY = ENV['GITHUB_API_KEY']