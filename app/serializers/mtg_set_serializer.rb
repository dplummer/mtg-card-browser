class MtgSetSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :release_type, :release_date, :block, :icon

  def icon
    if icon = object.default_icon
      "/images/icons/#{icon.filename}"
    end
  end
end
