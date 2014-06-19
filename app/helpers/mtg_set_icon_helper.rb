module MtgSetIconHelper
  def icon_url(icon)
    if icon
      "/images/icons/#{icon.filename}"
    end
  end
end
