# Sample Maid rules file -- some ideas to get you started: https://github.com/benjaminoakes/maid-example
# For more help on Maid:
#
# * Run `maid help`
# * Read the README, tutorial, and documentation at https://github.com/benjaminoakes/maid#maid
# * Ask me a question over email (hello@benjaminoakes.com) or Twitter (@benjaminoakes)
# * Check out how others are using Maid in [the Maid wiki](https://github.com/benjaminoakes/maid/wiki)

Maid.rules do

  # My custom folders
  download_archive = '/Volumes/Data/Users/joe/DownloadsArchive/'
  desktop_archive = '/Volumes/Data/Users/joe/tmpslow/'
  camera_uploads = '/Volumes/Data/Users/joe/Dropbox/Camera Uploads/'

  rule 'Clean Downloads folder' do
    # These can generally be downloaded again very easily if needed... but just in case, give me a few days before trashing them.
    dir('~/Downloads/*.{apk,deb,dmg,exe,pkg,rpm,app}').each do |p|
      trash(p) if 7.days.since?(accessed_at(p))
    end

    # Trash .zips with OSX apps inside
    osx_app_extensions = %w(app dmg pkg wdgt mpkg)
    osx_app_patterns = osx_app_extensions.map { |ext| (/\.#{ext}\/$/) }
    zips_with_osx_apps_inside = dir('~/Downloads/*.zip').select do |path|
      candidates = zipfile_contents(path)
      candidates.any? { |c| osx_app_patterns.any? { |re| c.match(re) } }
    end
    trash(zips_with_osx_apps_inside)

    # Trash dupes
    trash(verbose_dupes_in('~/Downloads/*'))

    dir('~/Downloads/*').each do |p|
      # Archive old downloads and trash original
      if 2.week.since?(created_at(p))
        sync(p, download_archive+File.basename(p))
        trash(p)
      end
    end

    dir('~/Downloads/*').each do |p|
      # Archive large downloads to slow disk
      if File.stat(p).size > 1000000000 # 1GB
        sync(p, download_archive+File.basename(p))
        trash(p)
      end
    end

    # Trash old download archive
    dir(download_archive + '*').each do |p|
      trash(p) if 60.days.since?(accessed_at(p))
    end
  end

  rule 'Clean Desktop folder' do
    # Archive old desktop items
    dir('~/Desktop/*').each do |path|
      if 7.day.since?(accessed_at(path))
        move(path, desktop_archive)
      end
    end

    # Trash old desktop archive
    dir(desktop_archive + '*').each do |p|
      trash(p) if 60.days.since?(accessed_at(p))
    end
  end

  rule 'Keep only last 500 Dropbox photos for screensaver' do
    trash dir(camera_uploads + '*.jpg').sort_by { |x| File.stat(x).mtime }[0..-500]
  end
end
