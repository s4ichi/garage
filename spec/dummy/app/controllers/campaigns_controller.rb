class CampaignsController < ApiController
  include Garage::RestfulActions

  def require_resource
    @resource = Campaign.find(params[:id])
  end

  def require_resources
    @resources = Campaign.all
  end

  def respond_with_resource_options
    { to_resource_options: { current_user: current_resource_owner } }
  end
end
