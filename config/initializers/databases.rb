FEED_DB = YAML.load_file(File.join(Rails.root, "config", "feed_database.yml"))[Rails.env.to_s]
VPCH_DB = YAML.load_file(File.join(Rails.root, "config", "vpch_database.yml"))[Rails.env.to_s]
LSD_DB = YAML.load_file(File.join(Rails.root, "config", "lsd_database.yml"))[Rails.env.to_s]
MSE_DB = YAML.load_file(File.join(Rails.root, "config", "mse_database.yml"))[Rails.env.to_s]
FIFA_DB = YAML.load_file(File.join(Rails.root, "config", "fifa_database.yml"))[Rails.env.to_s]
FRMR_DB = YAML.load_file(File.join(Rails.root, "config", "frmr_database.yml"))[Rails.env.to_s]
DLO_DB = YAML.load_file(File.join(Rails.root, "config", "dlo_database.yml"))[Rails.env.to_s]