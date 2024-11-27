class User < ApplicationRecord
    has_secure_password
    has_many :posts, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # เพิ่มการแปลงอีเมลให้เป็นตัวพิมพ์เล็กก่อนบันทึกในฐานข้อมูล
  before_save :downcase_email
  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end