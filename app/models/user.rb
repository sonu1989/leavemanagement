class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  auto_increment :employee_id
  
  mount_uploader :image, ImageUploader

  belongs_to :manager, class_name: "User"
  has_many :employees, class_name: "User", foreign_key: :manager_id
  has_many :leaves, dependent: :destroy
  has_many :balances
  has_many :reviews
  has_many :review_requests, class_name: 'ReviewRequest', foreign_key: :reviewer_id

  validates_presence_of :first_name, :last_name, :mobile,:role, :joining_date
  validates :mobile, length: { maximum: 10, minimum: 10 }

  after_create :set_employee_id

  enum role: [:employee, :manager, :admin]

  default_scope {where(deleted: false)}
  
  scope :all_employees,-> { where.not(role: "admin")}
  scope :managers,-> {where(role:"manager")}
  scope :admins,-> {where(role:"admin")}


  def user_name
  	first_name.to_s.capitalize + " " + last_name.to_s.capitalize
  end

  def is_employee?
    self.role == 'employee'
  end
  
  def is_manager?
    self.role == 'manager'
  end
  
  def is_admin?
    self.role == 'admin'
  end

  def leave_balance
    balance = self.balances.order('created_at DESC').first
    balance ? balance.main_balance.to_f : 0.0
  end

  def over_all_rating
    self.reviews.where(created_at: ((Time.zone.now - 12.months).end_of_day)..(Time.zone.now.beginning_of_day))
  end

  def avergae_rating
    reviews = over_all_rating
    reviews.map(&:rating).sum / reviews.size if reviews.size > 0
  end

  def unapproved_leaves
    unapproved_leave = self.leaves.where("start_date >= ? AND start_date <= ?", Time.now.beginning_of_month, Time.now.end_of_month).where(status: 'Unapproved').count
  end

  def add_leave_balance
    month = Time.now.month
    number_of_day = ((month % 3) == 0 ? 2 : 1)
    number_of_day = (number_of_day / 2.0) unless (self.joining_date.present? && self.joining_date.to_s.split("-")[2].to_i) < 15
    self.balances.create(main_balance: number_of_day, balance_added: number_of_day )   
  end

  def set_employee_id
    user = User.unscoped.order(:employee_id).last
    self.employee_id = user.employee_id+1
  end

  def self.to_csv(month)
    attributes = ['Employee Id', 'Name', 'Email', 'Leave Balance', 'Joining Date', 'Unapproved leaves']
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        balance = user.balances.order('created_at DESC').select{|balance| balance.created_at.month == month.to_i }.first
        main_balance = balance.try(:main_balance)
        employee = [user.employee_id,user.user_name,user.email, main_balance, user.joining_date, user.unapproved_leaves]
        csv << employee
      end
    end
  end
end
