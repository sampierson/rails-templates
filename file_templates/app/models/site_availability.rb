class SiteAvailability < EnumerateIt::Base
   associate_values(
     :down                => 0,
     :admins_only         => [20,  :admins_only],
     :prevent_user_logins => [40,  :prevent_user_logins],
     :prevent_new_signups => [80,  :prevent_new_signups],
     :fully_operational   => [100, :fully_operational]
   )

  def self.for_select
    to_a.reject { |x| x.last == DOWN }.sort { |x,y| x.last <=> y.last }
  end
end
