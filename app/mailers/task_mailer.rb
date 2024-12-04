class TaskMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.task_mailer.task_created.subject
  #
  def task_created(task)
    @task = task
    @user = task.user
    mail(to: @user.email, subject: 'New Task Created')
  end
end
