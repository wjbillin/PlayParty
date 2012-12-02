package eecs285.proj4.naugust;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

public class HostQueueGUI extends QueueGUI
{
  
  private JButton play;
  private JButton pause;
  private JButton skip;
  private JButton delete;
  private JPanel bottomPanel;
  private HomeActionListener actionListener;
  
  
  public HostQueueGUI()
  {
    super();
    
    actionListener = new HomeActionListener();
    
    //play = new JButton();
    ImageIcon icon = new ImageIcon("play.png");
    Image img = icon.getImage() ;  
    Image newimg = img.getScaledInstance( 30, 30,  java.awt.Image.SCALE_SMOOTH ) ;  
    icon = new ImageIcon( newimg );
    play = new JButton(icon);
    
    play.addActionListener(actionListener);
    //play.addActionListener()
    
   // pause = new JButton("Pause");
    ImageIcon icon2 = new ImageIcon("pause.png");
    Image img2 = icon2.getImage() ;  
    Image newimg2 = img2.getScaledInstance( 30, 30,  java.awt.Image.SCALE_SMOOTH ) ;  
    icon2 = new ImageIcon( newimg2 );
    pause = new JButton(icon2);
    
    pause.addActionListener(actionListener);
    
   // skip = new JButton("skip");
    ImageIcon icon3 = new ImageIcon("skip.png");
    Image img3 = icon3.getImage() ;  
    Image newimg3 = img3.getScaledInstance( 30, 30,  java.awt.Image.SCALE_SMOOTH ) ;  
    icon3 = new ImageIcon( newimg3 );
    skip = new JButton(icon3);
    
    skip.addActionListener(actionListener);
    
    //delete = new JButton("delete");
    ImageIcon icon4 = new ImageIcon("delete.png");
    Image img4 = icon4.getImage() ;  
    Image newimg4 = img4.getScaledInstance( 30, 30,  java.awt.Image.SCALE_SMOOTH ) ;  
    icon4 = new ImageIcon( newimg4 );
    delete = new JButton(icon4);
    
    delete.addActionListener(actionListener);
    
    
    JPanel bottomPanel = new JPanel(new FlowLayout());
    bottomPanel.add(play);
    bottomPanel.add(pause);
    bottomPanel.add(skip);
    bottomPanel.add(delete);
    
    add(bottomPanel, BorderLayout.SOUTH);
  }
  
  public class HomeActionListener implements ActionListener
  {
    public void actionPerformed(ActionEvent event)
    {
      
    }
  }
  
  
}