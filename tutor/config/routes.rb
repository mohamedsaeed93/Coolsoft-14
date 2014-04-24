Tutor::Application.routes.draw do

	devise_for :teaching_assistants
	devise_for :students
	devise_for :lecturers

	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# Example of regular route:
	#   get 'products/:id' => 'catalog#view'
	# 	get 'products/index'
	post 'solutions/compile_solution' => 'problems#show'
	post 'courses/new' => 'courses#new'
	post 'courses/share' => 'courses#share'
	get 'courses/sign_up'
	get 'students/get_performance' => 'students#get_performance'
    get 'students/solved_problems' => 'students#solved_problems'
    get 'students/failed_problems' => 'students#failed_problems'
    post 'students/get_performance' => 'students#get_performance'
    post 'students/solved_problems' => 'students#solved_problems'
    post 'students/failed_problems' => 'students#failed_problems'
    get 'students/incomplete_problems' => 'students#incomplete_problems'
	post 'solutions/execute' => 'problems#show'
	post 'debuggers/:id' => 'debuggers#start'

	# You can have the root of your site routed with "root"
	root 'site#index'


	# Example of named route that can be invoked with purchase_url(id: product.id)
	#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products
	resources :courses
	resources :test_cases
	resources :model_answers
	resources :problems_by_tas
	resources :solutions
	resources :problems
	resources :topics
	resources :posts
	resources :facebook

	# Example resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end
	resources :tracks do
		member do
			get 'getProblems'
		end
	end
	resources :discussion_boards do
		member do
			post 'toggle'
		end
	end
	resources :model_answers do
		post "model_answers/new"
	end
	# Example resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Example resource route with more complex sub-resources:
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', on: :collection
	#     end
	#   end
	resources :courses do
		post 'topics/new' => 'topics#new'
		resources :topics
	end

	# Example resource route with concerns:
	#   concern :toggleable do
	#     post 'toggle'
	#   end
	#   resources :posts, concerns: :toggleable
	#   resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end

end
