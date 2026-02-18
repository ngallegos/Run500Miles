Configuration.find_or_create_by(key: 'secret-word')    { |c| c.value = 'angusbeef' }
Configuration.find_or_create_by(key: 'quote-content')  { |c| c.value = 'Run your best.' }
Configuration.find_or_create_by(key: 'quote-source')   { |c| c.value = 'Anonymous' }
Configuration.find_or_create_by(key: 'jquery-ui-theme') { |c| c.value = 'smoothness' }
