class Task < ApplicationRecord
  include AASM

  belongs_to :author, class_name: 'User'

  validates :name, presence: true
  validates :description, presence: true
  validates :author, presence: true
  validates :deadline, presence: true

  aasm column: :state do
    state :draft, initial: true
    state :in_progress, :cancelled, :done

    event :start do
      transitions from: :draft, to: :in_progress
    end

    event :cancel do
      transitions from: :in_progress, to: :cancelled
    end

    event :finish do
      transitions from: :in_progress, to: :done
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ['deadline', 'state']
  end
end
