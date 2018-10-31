Rails.application.routes.draw do

        match "/404", :to => "errors#not_found", :via => :all

	post 'main/monitoring'



	root 'main#index'


	resources :main, only: :index do
		collection do
			get 'profile'
			get 'employee'
			get 'unloading_xls'
		end
		member do
			put 'update_user'
		end
	end
	namespace :frmr do
		resources :doctors, only: :index do
			collection do
				get 'xls'
				get 'search_surname'
				get 'search_code'
				post 'search'
			end
		end
		# resources :incoming_documents, only: :index do
		# 	member do
		# 		post 'download'
		#
		# 	end
		# end

		resources :outcoming_documents, only: [:index, :destroy] do
			collection do
				post 'upload'
			end
			member do
				get 'download'
			end
		end

		resources :hdbk, only: [] do
			collection do
				get 'speciality'
				get 'search_speciality'
				post 'search_speciality'
				get 'position'
				get 'search_position'
				post 'search_position'
				get 'search_by_pcode'
				get 'search_by_pname'

				get 'search_by_scode'
				get 'search_by_sname'

				get 'download_position'
				get 'download_speciality'
			end
		end
	end



	resources :fifa do
		collection do
			# post 'index'
			get 'get_pattern'
			post 'search'
			get 'search'
			get 'get_report'
		end

		member do
			get 'group'
		end
	end

	resources :notify

	get 'ahd' => 'ahd#index'
	post 'ahd_convert' => 'ahd#convert'
	match '/ahd/howdo', :to => redirect('/AHD.pdf'), via: :get

	resources :request do
		member do
			post 'closing_request'
		end
		collection do
			get 'closed'
			get 'opened'
		end
	end

  devise_for :users, controllers: { sessions: 'users/sessions', :confirmations => 'confirmations' }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :documents, only: [:index, :show]

	namespace :vpch do

		resources :analyses do

			collection do
				get 'autocomplete_mkb_handbook_code'
				get 'update_diagnostic_first'
				get 'info'
				get 'last_reception'
				# get 'create_diagnosis'
			end
			member do
				# post 'add_result'
				get 'print'
				post 'delete_patient_from_reestr'
				post 'block_patient'
			end
		end

		resources :registries do
			collection do
				post 'add_to_exist_registry'
			end
			member do
				get 'print'
				get 'disband_registry'
			end
		end

		resources :result do
			collection do
				post 'add_norma_onko'
				post 'add_spid_key'
				post 'analys_spid'
				post 'send_spid_registry'
				post 'send_taken_registry'
				# post 'send_spid_result'
				post 'download_spid_result'
			end
			member do
				post 'add_result'
				get 'analyse_update'
			end
		end

		resources :report do
			collection do
				post 'create_xls_report'
				get 'download_svod'
				get 'download_for_lpu'
				get 'download_for_onko'
				get 'download_for_spid'
			end
		end

	end

	namespace :admin do

		resources :organizations do
			collection do
				post 'search'
				get 'search_name'
			end
		end

		namespace :frmr do
			resources :incoming_documents, only: [:index, :update] do
				member do
					post 'download'
				end
				collection do
					post 'search'
					get 'search'
				end
			end

			namespace :hdbk do
				resources :speciality do
					collection do
						post 'search'
						get 'search_by_code'
						get 'search_by_name'
						get 'download'
					end
				end
				resources :position do
					collection do
						post 'search'
						get 'search_by_code'
						get 'search_by_name'
						get 'download'
					end
				end
		end

  	resources :documents

		resources :monitoring do
			collection do
				post 'get_data_chart'
			end
		end

	end



	namespace :mse do
		resources :patient, only: [] do
			collection do
				get 'new_card'
				get 'closed_card'
				get 'search'
				post 'search'
				get 'xls'
			end
		end
		resources :prg_rhb, only: [:create, :destroy]
		resources :report, only:[] do
			collection do
				get 'monitoring'
				get 'xls'
				get 'print'
			end
		end
	end
	
	namespace :admin do
  	resources :documents
		resources :food

		resources :sectors, only: [:index, :update] do
			collection do
				post 'lsd_update'
				post 'update_sectors'
				post 'add_from_rmis'
			end
		end
		resources :doctors do
			collection do
				post 'lsd_update'
				post 'update_doctors'
				post 'add_from_rmis'
			end
		end
		resources :users do
			collection do
				get 'search_login'
				get 'search_email'
				get 'search_org'
				get 'search_fio'
				post 'search_user'
			end
		end
	end
end

