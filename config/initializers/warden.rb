# frozen_string_literal: true

Warden::Strategies.add(:api) do
  # def valid?
  #   params[:user][:username] && params[:user][:password]
  # end

  def authenticate!
    I18n.locale = :fr

    if params[:user]
      username = params[:user][:username]
      password = params[:user][:password]

      user = User.find_by(username: username)
      first_name, last_name, valid_user = _exist_username_password(username, password)

      if user&.valid_password?(password)

        # Weekly Schedule
        WeeklyShedule.create_schedule(user, username)

        # Next Exam
        NextExams.create_next_exam(user, username)

        # Completed Exam
        CompletedExams.create_completed_exam(user, username)

        success!(user)

      elsif valid_user

        create_user(username, password, first_name, last_name)
        user = User.find_by(username: username)

        if user&.valid_password?(password)

          # Weekly Schedule
          WeeklyShedule.create_schedule(user, username)

          # Next Exam
          NextExams.create_next_exam(user, username)

          # Completed Exam
          CompletedExams.create_completed_exam(user, username)

          success!(user)

        end
      else
        request.env['warden'].custom_failure!
        fail!('Votre utilisateur ou mot de passe est incorrect / inexistant')
      end
    else
      request.env['warden'].custom_failure!
      fail!(I18n.t('devise.failure.inactive'))
    end
  end

  # Compare DDN and Password
  def _exist_username_password(username, password)
    schema_name = 'horacio_bijouterie_students'
    table_name = 'tblElèves'
    conn = ActiveRecord::Base.connection
    results = nil

    begin
      results = conn.execute(format('SELECT * FROM "horacio_bijouterie_students"."tblElèves" WHERE "CodePermanent"=\'%s\'', username.to_s)).first
    rescue StandardError
    end

    first_name = nil
    last_name = nil
    valid_user = false

    if results.present?
      valid_user = true if results['DDN'].strftime('%d%m%Y') == password
      first_name = results['Prénom'].capitalize
      last_name = results['NomElève'][0,1]
    end

    [first_name, last_name, valid_user]
  end

  # Create new user
  def create_user(username, password, first_name, last_name)
    @user = User.new(username: username, password: password, first_name: first_name, last_name: last_name)
    @user.save
  end
end
