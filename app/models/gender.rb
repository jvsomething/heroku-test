class Gender
  TYPE = [
      MALE = [0, 'Male'],
      FEMALE = [1, 'Female']
  ]

  def self.parse_gender(g)
    TYPE.each do |type|
      if type[0] == g
        return type
      end
    end
  end
end