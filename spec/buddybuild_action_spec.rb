describe Fastlane::Actions::BuddybuildAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The buddybuild plugin is working!")

      Fastlane::Actions::BuddybuildAction.run(nil)
    end
  end
end
