class Mailer < ActionMailer::Base

  def generic_mail(title)
    @smer = Smer.find_by_title(title)
    @recipients = @smer.recipients
    @from = @smer.from
    @subject = @smer.subject
    @charset = "utf-8"
    @content_type = "multipart/alternative"
  end
end
