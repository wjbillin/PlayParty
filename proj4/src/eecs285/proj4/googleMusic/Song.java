package eecs285.proj4.googleMusic;


import oracle.jrockit.jfr.settings.JSONElement;

import java.util.Comparator;

/**
 * Created with IntelliJ IDEA.
 * User: Savannah
 * Date: 11/25/12
 * Time: 7:23 PM
 * To change this template use File | Settings | File Templates.
 */
public class Song {

  Song(String title, String artist, String length, String streamURL){
    this.artist = artist;
    this.length = length;
    this.title = title;
    this.streamURL = streamURL;
  }

  Song(JSONElement jsonElement){

  }

  public String getSongStr(){
    return "Artist: " + artist + " Title: " + title + " Album: " + album + length;
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

  public final static String ARTIST_FIELD = "artist";
  public final static String TITLE_FIELD = "title";
  public final static String ALBUM_FIELD = "album";



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

  private String streamURL;
  private String artist;
  private String title;
  private String length;
  private String album;
}
