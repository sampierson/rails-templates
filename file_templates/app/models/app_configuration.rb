class AppConfiguration < ActiveRecord::Base
  include EnumerateIt

  has_enumeration_for :site_availability, :with => SiteAvailability

  def self.instance
    @instance ||= first || create!
  end

  def self.site_availability
    instance.site_availability
  end
end
