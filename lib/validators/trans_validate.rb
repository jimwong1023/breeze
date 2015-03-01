module TransValidate
  class GoodnessValidator < ActiveModel::Validator
    def validate(record)
      if record.first_name == "Evil"
        record.errors[:base] << "This person is evil"
      end
    end
  end
end
