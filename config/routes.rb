Rails.application.routes.draw do
	root "cmanager#index"
	get 'cmanager/index'
	
	# ReactJS Callbacks somewhat API
	get '/getuserid', to: 'users#json_id_current_user'
	post '/newcampaign', to: 'campaigns#create_json'
	get '/showcampaign', to: 'campaigns#show_json'
	delete '/deletecampaign/:id', to: 'campaigns#destroy_json'
	post '/newbanner', to: 'banners#create_json'
	get '/showbanner', to: 'banners#show_json'
	delete '/deletebanner/:id', to: 'banners#destroy_json'

	resources :users do
		resources :campaigns
		resources :banners
	end
	#resources :campaigns
	
	# Authentication 
	get '/newuser', to: 'users#new'
	get    '/login',   to: 'sessions#new'
	post   '/login',   to: 'sessions#create'
	delete '/logout',  to: 'sessions#destroy'
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
