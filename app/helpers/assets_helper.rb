module AssetsHelper
  def built_asset_present?(asset_name)
    Rails.root.join("app/assets/builds", asset_name).exist?
  end
end
