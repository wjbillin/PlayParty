package eecs285.proj4.naugust;

import java.awt.BorderLayout;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.SwingUtilities;


public class HomeGuiClass extends JFrame {
  
  
  public static void main(String[] args) {
    SwingUtilities.invokeLater(new Runnable() {

        public void run() {
            new HomeGuiClass("Welcome").setVisible(true);
            
        }
    });
  }
  
  private JLabel welcomeText;
  private JButton logIn;
  private JButton guest;
  private ActionListener logInListener;
  private ActionListener guestListener;
  static JDialog loginGui;
  
 
  
  public HomeGuiClass (String title) {
    
    super(title);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setResizable(false);
    
    setLayout(new BorderLayout());
    welcomeText = new JLabel("<html>Welcome to Google music sharing!<br> " +
                         "<&nbsp <&nbsp <&nbsp <&nbsp <&nbsp <&nbsp " +
                         "<&nbsp Would you like to...?</html>", 
                         JLabel.CENTER);
    add(welcomeText, BorderLayout.NORTH);
    
    //JPanel buttonPanel = new JPanel(new GridLayout(1,2));
    Panel buttonPanel = new Panel();
    logIn = new JButton("Log Into Google");
    logInListener = new LoginButtonListener();
    logIn.addActionListener(logInListener);
    buttonPanel.add(logIn);
    guest = new JButton("Continue as Guest");
    guestListener = new GuestButtonListener();
    guest.addActionListener(guestListener);
    buttonPanel.add(guest);
    add(buttonPanel, BorderLayout.SOUTH);
    setLocationRelativeTo(null);
    pack();
   

  }
  
  public class LoginButtonListener implements ActionListener {

    public void actionPerformed(ActionEvent e) {
      setVisible(false); 
      new LoginGuiClass(HomeGuiClass.this, "Input Inventory Item").setVisible(true);

    }
  }
  
  public class GuestButtonListener implements ActionListener {

    public void actionPerformed(ActionEvent e) {
      setVisible(false);
      new JoinGuiClass(HomeGuiClass.this, "Join a Session").setVisible(true);

    }
  }

}
