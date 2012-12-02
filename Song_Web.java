<<<<<<< HEAD
/*******************************************************************************
 * Copyright (c) 2012 Jens Kristian Villadsen.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Public License v3.0
 * which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/gpl.html
 * 
 * Contributors:
 *     Jens Kristian Villadsen - initial API and implementation
 ******************************************************************************/
package partyManager.api.model;

import partyManager.Tune;

public class Song extends Tune
{
	private int totalTracks;
	private boolean subjectToCuration;
	private String name;
	private int totalDiscs;
	private String titleNorm;
	private String albumNorm;
	private int track;
	private String albumArtUrl;
	private String url;
	private float creationDate;
	private String albumArtistNorm;
	private String artistNorm;
	private double lastPlayed;
	private String metajamId;
	private int type;
	private int disc;

	public Song()
	{}

	public final String getMetajamId()
	{
		return metajamId;
	}

	public final void setMetajamId(String metajamId)
	{
		this.metajamId = metajamId;
	}

	public final boolean isSubjectToCuration()
	{
		return subjectToCuration;
	}

	public final void setSubjectToCuration(boolean subjectToCuration)
	{
		this.subjectToCuration = subjectToCuration;
	}

	public final String getAlbumArtUrl()
	{
		return albumArtUrl;
	}

	public final void setAlbumArtUrl(String albumArtUrl)
	{
		this.albumArtUrl = albumArtUrl;
	}

	public final void setGenre(String genre)
	{
		this.genre = genre;
	}

	public final void setBeatsPerMinute(int beatsPerMinute)
	{
		this.beatsPerMinute = beatsPerMinute;
	}
	public final String getAlbumArtistNorm()
	{
		return albumArtistNorm;
	}
	public final void setAlbumArtistNorm(String albumArtistNorm)
	{
		this.albumArtistNorm = albumArtistNorm;
	}
	public final String getArtistNorm()
	{
		return artistNorm;
	}
	public final void setArtistNorm(String artistNorm)
	{
		this.artistNorm = artistNorm;
	}

	public final void setAlbum(String album)
	{
		this.album = album;
	}
	public final double getLastPlayed()
	{
		return lastPlayed;
	}
	public final void setLastPlayed(double lastPlayed)
	{
		this.lastPlayed = lastPlayed;
	}
	public final int getType()
	{
		return type;
	}
	public final void setType(int type)
	{
		this.type = type;
	}
	public final int getDisc()
	{
		return disc;
	}
	public final void setDisc(int disc)
	{
		this.disc = disc;
	}

	public final void setId(String id)
	{
		this.id = id;
	}

	public final void setComposer(String composer)
	{
		this.composer = composer;
	}

	public final void setTitle(String title)
	{
		this.title = title;
	}

	public final void setAlbumArtist(String albumArtist)
	{
		this.albumArtist = albumArtist;
	}
	public final int getTotalTracks()
	{
		return totalTracks;
	}
	public final void setTotalTracks(int totalTracks)
	{
		this.totalTracks = totalTracks;
	}
	public final String getName()
	{
		return name;
	}
	public final void setName(String name)
	{
		this.name = name;
	}
	public final int getTotalDiscs()
	{
		return totalDiscs;
	}
	public final void setTotalDiscs(int totalDiscs)
	{
		this.totalDiscs = totalDiscs;
	}
	public final void setYear(int year)
	{
		this.year = year;
	}
	public final String getTitleNorm()
	{
		return titleNorm;
	}
	public final void setTitleNorm(String titleNorm)
	{
		this.titleNorm = titleNorm;
	}
	public final void setArtist(String artist)
	{
		this.artist = artist;
	}
	public final String getAlbumNorm()
	{
		return albumNorm;
	}
	public final void setAlbumNorm(String albumNorm)
	{
		this.albumNorm = albumNorm;
	}
	public final int getTrack()
	{
		return track;
	}
	public final void setTrack(int track)
	{
		this.track = track;
	}
	public final void setDurationMillis(long durationMillis)
	{
		this.durationMillis = durationMillis;
	}
	public final void setDeleted(boolean deleted)
	{
		this.deleted = deleted;
	}
	public final String getUrl()
	{
		return url;
	}
	public final void setUrl(String url)
	{
		this.url = url;
	}
	public final float getCreationDate()
	{
		return creationDate;
	}
	public final void setCreationDate(float creationDate)
	{
		this.creationDate = creationDate;
	}
	public final int getPlaycount()
	{
		return playCount;
	}
	public final void setPlaycount(int playcount)
	{
		this.playCount = playcount;
	}
	public final void setRating(String rating)
	{
		this.rating = rating;
	}
	public final void setComment(String comment)
	{
		this.comment = comment;
	}

}
=======
package eecs285.proj4.naugust;
//package eecs285.proj4.naugust;

import java.lang.*;
//import net.sf.json.JSONObject;
import oracle.jrockit.jfr.settings.*;

import java.util.Comparator;

/**
 * Created with IntelliJ IDEA.
 * User: Savannah
 * Date: 11/25/12
 * Time: 7:23 PM
 * To change this template use File | Settings | File Templates.
 */
public class Song {

  Song(String title, String artist, String album, String length, String streamURL){
    this.artist = artist;
    this.length = length;
    this.title = title;
    this.streamURL = streamURL;
    this.album = album;
  }

  //Song(JSONElement jsonElement){

//  }

  public String getSongStr(){
    return "Artist: " + artist + " Title: " + title + " Album: " + album + " " + length;
  }

  @Override
  public String toString()
  {
    return getSongStr();
  }

  //Defines compare for each field to be sorted by
  //Returns a Comparator object
  public static Comparator<Song> getComparator(final String sortBy)
          throws Exception {
    if (ARTIST_FIELD.equals(sortBy)) {
      return new Comparator<Song>() {
        public int compare(Song item1, Song item2) {
          return item1.getArtist().toLowerCase().
                  compareTo(item2.getArtist().toLowerCase());
        }
      };
    } else if (TITLE_FIELD.equals(sortBy)) {
      return new Comparator<Song>() {
        public int compare(Song item1, Song item2) {
          return item1.getTitle().toLowerCase().
                  compareTo(item2.getTitle().toLowerCase());
        }
      };
    } else if (ALBUM_FIELD.equals(sortBy)) {
      return new Comparator<Song>(){
        public int compare(Song item1, Song item2) {
          return item1.getAlbum().toLowerCase().compareTo(
                  item2.getAlbum().toLowerCase());
        }
      };

    } else {
      throw new Exception("Invalid sorting key.");
    }
  }



  public String getArtist() {
    return artist;
  }

  public String getTitle() {
    return title;
  }

  public String getAlbum() {
    return album;
  }

  public String getStreamURL() {
    return streamURL;
  }

  public final static String ARTIST_FIELD = "Artist";
  public final static String TITLE_FIELD = "Title";
  public final static String ALBUM_FIELD = "Album";
  public final static String[] stringsForSort = {ARTIST_FIELD, TITLE_FIELD, ALBUM_FIELD};

  private String streamURL;
  private String artist;
  private String title;
  private String length;
  private String album;
}
>>>>>>> 5641da32088f2d2533f44bbc7e13f75234160e50
