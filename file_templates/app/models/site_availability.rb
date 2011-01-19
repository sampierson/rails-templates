class SiteAvailability < EnumerateIt::Base
   associate_values(
     :down                => 0,
     :admins_only         => [20,  I18n.t('site_availability.admins_only')],
     :prevent_user_logins => [40,  I18n.t('site_availability.prevent_user_logins')],
     :prevent_new_signups => [80,  I18n.t('site_availability.prevent_new_signups')],
     :fully_operational   => [100, I18n.t('site_availability.fully_operational')]
   )

  def self.for_select
    to_a.reject { |x| x.last == DOWN }.sort { |x,y| x.last <=> y.last }
  end
end
