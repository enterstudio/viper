class Bio < ActiveRecord::Base
  belongs_to :user
  
  def after_initialize
    clear_text_fields!
  end
  
  QUESTIONS = %w(about interests music films television books heroes)
  # A constant for everything except the bio
  FAVORITES = QUESTIONS - %w(about)
  
  acts_as_ferret
  acts_as_textiled :about, :interests, :music, :films, :television, :books, :heroes
  
  validates_length_of QUESTIONS,
                      :maximum => 65000
                       
  private
  
  def clear_text_fields!
    QUESTIONS.each do |question|
      self[question] ||=  ""
    end
  end
  
end
