package eecs285.proj4.googleMusic;


import java.util.ArrayList;
import java.util.Collections;

/**
 * Created with IntelliJ IDEA.
 * User: Savannah
 * Date: 11/25/12
 * Time: 10:37 PM
 * To change this template use File | Settings | File Templates.
 */
public class SongList extends ArrayList<Song>{

  SongList(){
    super();
  }


  public SongList searchFilter(String searchBy, String searchStr) {
    SongList filteredList = new SongList();
    if (Song.ARTIST_FIELD.equals(searchBy)){
      for (Song song : this) {
        if (song.getArtist().toLowerCase().contains(searchStr.toLowerCase())){
          filteredList.add(song);
        }
      }
    } else if(Song.ALBUM_FIELD.equals(searchBy)){
      for (Song song : this) {
        if (song.getAlbum().toLowerCase().contains(searchStr.toLowerCase())){
          filteredList.add(song);
        }
      }
    } else if(Song.TITLE_FIELD.equals(searchBy)){
      for (Song song : this) {
        if (song.getTitle().toLowerCase().contains(searchStr.toLowerCase())){
          filteredList.add(song);
        }
      }
    } else {
      System.out.print("Invalid Search Field");
      System.exit(-1);
    }
    return filteredList;
  }

  public void sortInventoryItemList(String sortBy){
    try {
      Collections.sort(this, Song.getComparator(sortBy));
    } catch (Exception invalidSortKey){
      invalidSortKey.printStackTrace();
      System.exit(-1);
    }
  }
}
