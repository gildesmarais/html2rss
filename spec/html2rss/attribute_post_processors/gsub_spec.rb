RSpec.describe Html2rss::AttributePostProcessors::Gsub do
  context 'with string pattern' do
    context 'with string replacement' do
      subject {
        described_class.new('Foo bar and boo',
                            options: { 'pattern' => 'boo', 'replacement' => 'baz' }).get
      }

      it { is_expected.to eq 'Foo bar and baz' }
    end
  end

  context 'with pattern being a Regexp as String' do
    context 'with hash replacement' do
      subject {
        described_class.new('hello',
                            options: { 'pattern' => '/[eo]/', 'replacement' => { 'e' => 3, 'o' => '*' } }).get
      }

      it { is_expected.to eq 'h3ll*' }
    end
  end
end