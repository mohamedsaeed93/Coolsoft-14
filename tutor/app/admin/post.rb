ActiveAdmin.register Post do

  menu parent: "Disc",priority:2
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :title,:img,:content,:views_count,:discussion_board_id,:owner_id,
                :owner_type,:created_at,:updated_at
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
end
