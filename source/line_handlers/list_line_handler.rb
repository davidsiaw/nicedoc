class ListLineHandler < SingleLineHandler
  def handle(line, blocks, curblock)
    sbt = single_block_type(line)

    return curblock, :notconsumed if sbt.nil?
    return curblock, :notconsumed unless sbt[:tag] == :ul || sbt[:tag] == :ol

    if curblock.lines.length != 0 && curblock.type != :list
      blocks << curblock
      curblock = Block.new
    end

    a = Block.new
    a.type = :list
    a.tag = sbt[:tag]
    a.info = {
      tags: []
    }

    a.info[:last] = a.info[:tags].first

    if blocks.last.nil?
      blocks << a
    elsif blocks.last.type == :list
      a = blocks.last
    else
      blocks << a
    end

    # move to the lowest level available
    cur = a.info[:last]
    loop do
      break if cur.nil?
      break if cur[:level] < sbt[:level]

      if cur[:level] == sbt[:level]
        if cur[:tag] != sbt[:tag].to_sym
          cur = cur[:parent]
        end

        break
      end

      if cur[:level] > sbt[:level]
        cur = cur[:parent]
      end
    end

    if cur.nil?
      cur = {
        type: :branch,
        parent: nil,
        level: sbt[:level],
        tag: sbt[:tag].to_sym,
        children: []
      }
      a.info[:tags] << cur

    elsif sbt[:level] > cur[:level]
      newcur = {
        type: :branch,
        parent: cur,
        level: sbt[:level],
        tag: sbt[:tag].to_sym,
        children: []
      }

      pos = a.info[:tags].length
      a.info[:tags] << newcur
      cur[:children] << pos
      cur = newcur
    end

    a.info[:last] = cur

    # insert the leaf

    new_leaf = {
      type: :leaf,
      parent: a.info[:last],
      text: [sbt[:text]]
    }

    pos = a.info[:tags].length
    a.info[:tags] << new_leaf
    a.info[:last][:children] << pos

    return curblock, :consumed
  end
end
