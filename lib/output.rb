# Copyright (c) 2013-2014 SUSE LLC
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

module Machinery
  def self.print_output(output, options = {})
    if options[:no_pager] || !$stdout.tty?
      puts output
    else
      if !ENV['PAGER'] || ENV['PAGER'] == ''
        ENV['PAGER'] = 'less'
        ENV['LESS'] = 'FSRX'
        begin
          check_package("less")
          IO.popen("$PAGER", "w") { |f| f.puts output }
        rescue Machinery::MissingRequirementsError
          puts output
        end
      else
        IO.popen("$PAGER &>/dev/null", "w") { |f| f.close }
        if $?.success?
          IO.popen("$PAGER", "w") { |f| f.puts output }
        else
          raise(Machinery::InvalidPagerError.new("'#{ENV['PAGER']}' could not " \
            "be executed. Use the --no-pager option or modify your $PAGER " \
            "bash environment variable to display output.")
          )
        end
      end
    end
  end
end