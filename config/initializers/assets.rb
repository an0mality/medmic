# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( admin/sectors.js )
Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( moment.min.js )
Rails.application.config.assets.precompile += %w( moment_ru.js )
Rails.application.config.assets.precompile += %w( bootstrap-datetimepicker.min.js )
Rails.application.config.assets.precompile += %w( ckeditor/*)
Rails.application.config.assets.precompile += %w( notify.js )
Rails.application.config.assets.precompile += %w( admin/doctors.js )
Rails.application.config.assets.precompile += %w( admin/users.js )
Rails.application.config.assets.precompile += %w( feed/patient_feed.js )
Rails.application.config.assets.precompile += %w( autocomplete-rails.js )
Rails.application.config.assets.precompile += %w( vpch/analyses.js )
Rails.application.config.assets.precompile += %w( vpch/vpch_print.js )
Rails.application.config.assets.precompile += %w( vpch/result.js )
Rails.application.config.assets.precompile += %w( vpch/registries.js )
Rails.application.config.assets.precompile += %w( feed/recipe.js )
Rails.application.config.assets.precompile += %w( feed/report.js )
Rails.application.config.assets.precompile += %w( mse/mse_patient.js )
Rails.application.config.assets.precompile += %w( mse/report.js )
Rails.application.config.assets.precompile += %w( fifa.js )
Rails.application.config.assets.precompile += %w( admin/monitoring.js )
Rails.application.config.assets.precompile += %w( cadesplugin_api.js )
Rails.application.config.assets.precompile += %w( admin/frmr/doctors.js )
Rails.application.config.assets.precompile += %w( admin/frmr/doctors_new.js )
Rails.application.config.assets.precompile += %w( admin/frmr/doctors.css )
Rails.application.config.assets.precompile += %w( best_in_place.jquery-ui.js )
Rails.application.config.assets.precompile += %w( admin/frmr/hdbk/speciality.js )
Rails.application.config.assets.precompile += %w( admin/frmr/hdbk/position.js )
Rails.application.config.assets.precompile += %w( admin/frmr/hdbk/organization.js )
Rails.application.config.assets.precompile += %w( frmr/doctors.js )
Rails.application.config.assets.precompile += %w( frmr/hdbk.js )
Rails.application.config.assets.precompile += %w( admin/doctors.js )
Rails.application.config.assets.precompile += %w( jquery.maskedinput.min.js )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
