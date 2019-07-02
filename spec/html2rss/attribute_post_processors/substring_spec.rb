RSpec.describe Html2rss::AttributePostProcessors::Substring do
  context 'with end' do
    subject { described_class.new('foobarbaz', { 'start' => 3, 'end' => 5 }, nil).get }
    it { is_expected.to eq 'bar' }
  end

  context 'without end' do
    subject { described_class.new('foobarbaz', { 'start' => 3 }, nil).get }
    it { is_expected.to eq 'barbaz' }
  end
end
