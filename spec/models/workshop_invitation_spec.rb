require 'spec_helper'

describe WorkshopInvitation do
  context 'methods' do
    let(:invitation) { Fabricate(:student_workshop_invitation) }
    let!(:accepted_invitation) { 2.times { Fabricate(:workshop_invitation, attending: true) } }

    it_behaves_like InvitationConcerns
  end

  context 'scopes' do
    it '#attended' do
      4.times { Fabricate(:attended_workshop_invitation) }

      expect(WorkshopInvitation.attended.count).to eq(4)
    end

    it '#not_accepted' do
      4.times { Fabricate(:workshop_invitation, attending: nil) }
      4.times { Fabricate(:workshop_invitation, attending: false) }

      expect(WorkshopInvitation.not_accepted.count).to eq(8)
    end

    it '#to_coaches' do
      6.times { Fabricate(:coach_workshop_invitation) }

      expect(WorkshopInvitation.to_coaches.count).to eq(6)
    end

    it '#to_student' do
      4.times { Fabricate(:student_workshop_invitation) }

      expect(WorkshopInvitation.to_students.count).to eq(4)
    end

    it '#year' do
      new_workshop = Fabricate(:workshop, date_and_time: Time.zone.now)
      old_workshop = Fabricate(:workshop, date_and_time: Time.zone.now - 2.years)

      4.times { Fabricate(:attended_coach, workshop: new_workshop) }
      5.times { Fabricate(:attended_coach, workshop: old_workshop) }

      expect(WorkshopInvitation.year(Time.zone.now.year).count).to eq(4)
      expect(WorkshopInvitation.year((Time.zone.now - 2.years).year).count).to eq(5)
    end
  end
end
