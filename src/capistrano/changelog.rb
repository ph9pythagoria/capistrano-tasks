#!/usr/bin/env ruby

#
# simple git changelog markdown generator
# @todo limit to tags ?
# @warn this is unfinished stuff

#FIRST COMMIT
#git log --format="%H" --pretty=oneline --reverse
#LAST TAG
#git describe --tags `git rev-list --tags --max-count=1`

changelog_content = String.new
separator = "==kikkikokko=="
cmdLog = `git log --decorate=full -E --format="%h%n%H%n%s%n%aN <%aE>%n%ad%n#{separator}" --date=short`
cmdTags = `git tag`
tags = Hash.new

cmdTags.split("\n").each do |tag|
    revision = `git rev-list #{tag} | head -n 1`.chomp()
    tags[revision] = tag
end

cmdLog.split("#{separator}").each do |entry|

    short, hash, comment, author, date = entry.strip.chomp.split("\n");

    # @todo test if first line, and not tagged, present untagged title

    if (tags.has_key?(hash))
        line = "\#\# #{tags[hash]} (#{date})"
        changelog_content += line +"\n"
        changelog_content += ("=" * line.length) +"\n"
    end

    # old style comments à la - comment - comment etc ...
    if (comment.to_s.strip() =~ /^- /)
        counter = 0
        comment.split("- ").compact.each do |com|
            if (! com.to_s.empty?)
                if (counter == 0)
                    changelog_content += "    * #{com} #{hash} #{date} \n"
                else
                    changelog_content += "    * #{com} \n"
                end
                counter = counter + 1
            end
        end
    else
       changelog_content += "    * #{comment} #{hash} #{date} \n"
    end

end

puts changelog_content