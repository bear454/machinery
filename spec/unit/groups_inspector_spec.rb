# Copyright (c) 2013-2016 SUSE LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 3 of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.   See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, contact SUSE LLC.
#
# To contact SUSE about this file by physical or electronic mail,
# you may find current contact information at www.suse.com

require_relative "spec_helper"

describe Machinery::GroupsInspector do
  let(:description) {
    Machinery::SystemDescription.new("systemname", Machinery::SystemDescriptionStore.new)
  }
  let(:filter) { nil }
  let(:group_content) {
    <<-EOF.gsub(/^\s+/, "").gsub(/\s+$/, "\n")
      root:x:0:
      tftp:x:493:dnsmasq,tftp
      +:::
    EOF
  }
  let(:expected_groups) {
    Machinery::GroupsScope.new(
      [
        Machinery::Group.new(
          name: "+",
          password: "",
          gid: nil,
          users: []
        ),
        Machinery::Group.new(
          name: "root",
          password: "x",
          gid: 0,
          users: []
        ),
        Machinery::Group.new(
          name: "tftp",
          password: "x",
          gid: 493,
          users: ["dnsmasq", "tftp"]
        )
      ]
    )
  }

  let(:system) { double }
  subject { Machinery::GroupsInspector.new(system, description) }

  describe "#inspect" do
    it "return an empty list when /etc/group is missing" do
      expect(system).to receive(:read_file).with("/etc/group").and_return(nil)

      subject.inspect(filter)

      expect(description.groups).to be_empty
      expect(subject.summary).to eq("Found 0 groups.")
    end

    it "returns the groups" do
      expect(system).to receive(:read_file).with("/etc/group").and_return(group_content)

      subject.inspect(filter)
      expect(description.groups).to eq(expected_groups)
      expect(subject.summary).to eq("Found 3 groups.")
    end

    it "can handle a missing newline at the end in /etc/group" do
      expect(system).to receive(:read_file).with("/etc/group").and_return(group_content.chomp)

      subject.inspect(filter)
      expect(description.groups).to eq(expected_groups)
    end

    it "returns sorted data" do
      expect(system).to receive(:read_file).with("/etc/group").and_return(group_content)

      subject.inspect(filter)
      names = description.groups.map(&:name)
      expect(names).to eq(names.sort)
    end
  end
end
