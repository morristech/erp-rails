class Coordinator < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, :rollnum, presence: true
  after_create :send_confirmation_mail

  private
  def send_confirmation_mail

  	fin = File.open "public/mail-templates/welcome.html"
  	html_text_from_file = fin.read
  	fin.close
  	replacer = StringEnumerator.new(:type => ["Coordinator"], :name => [self.name])
  	html_text_from_file = replacer.enumerate html_text_from_file

    mg_client = Mailgun::Client.new "key-74e2fcede7797b9b869f574c965c9b0d"
    mb_obj = Mailgun::MessageBuilder.new

    mb_obj.set_from_address("no-reply@erp.alumnicell.com", {"first"=>"SAC", "last" => "Internal ERP"});
    mb_obj.add_recipient(:to, self.email);
    mb_obj.set_subject("You have registered on the SAC ERP");
    mb_obj.set_text_body("Hello, Just letting you know that your account has been created, Regards, System Administrator.");
    mb_obj.set_html_body(html_text_from_file)

		puts "Sending the email, now!"

		mg_client.send_message("sandbox3a6bc1bbcfc149ba9e95376871456536.mailgun.org", mb_obj)

    puts "Mail has been sent! :D"

  end
end
