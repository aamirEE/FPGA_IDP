
// OUTPUT
int swap;
float temp = 1.0/360.0;
unsigned long a;
int z[8];
int ANS;
float ans_sin;
int c;
float i = 0.0;
float error = 0.05;
int shift = 1;                                                                                                  

void setup() {
pinMode(2, INPUT);
pinMode(3, INPUT); 
pinMode(4, INPUT);
pinMode(5, INPUT); 
pinMode(6, INPUT); 
pinMode(7, INPUT); 
pinMode(8, INPUT); 
pinMode(9, INPUT);
 
pinMode(30, OUTPUT); 
pinMode(31, OUTPUT); 
pinMode(32, OUTPUT); 
pinMode(33, OUTPUT); 
pinMode(34, OUTPUT); 
pinMode(35, OUTPUT); 
pinMode(36, OUTPUT); 
pinMode(37, OUTPUT); 
pinMode(38, OUTPUT); 
pinMode(39, OUTPUT); 
pinMode(40, OUTPUT); 
pinMode(41, OUTPUT); 
pinMode(42, OUTPUT); 
pinMode(43, OUTPUT); 
pinMode(44, OUTPUT); 
pinMode(45, OUTPUT);

//DAC
pinMode(22, OUTPUT); //LSB
pinMode(23, OUTPUT); 
pinMode(24, OUTPUT); 
pinMode(25, OUTPUT); 
pinMode(26, OUTPUT); 
pinMode(27, OUTPUT); 
pinMode(28, OUTPUT); 
pinMode(29, OUTPUT); 
Serial.begin(115200);
//Serial.flush();
delay(1000);

}

void loop(){
  
//Serial.println(a);
//while(!Serial.available()){}

//a = Serial.read();
/*
set_io angle[0] A5 // LSB
set_io angle[1] A2
set_io angle[2] C3
set_io angle[3] B4
set_io angle[4] D8
set_io angle[5] B9
set_io angle[6] B10
set_io angle[7] B11
set_io angle[8] B7 
set_io angle[9] B6
set_io angle[10] B3
set_io angle[11] B5
set_io angle[12] B8
set_io angle[13] A9
set_io angle[14] A10
set_io angle[15] A11
 */

///for(int i = 0; i < 360; i++){
  
  a = temp*i*65536;

  digitalWrite(45,a%2); // LSB
  a = (a>>1);
  digitalWrite(44,a%2); 
  a = (a>>1);
  digitalWrite(43,a%2); 
  a = (a>>1);
  digitalWrite(42,a%2); 
  a = (a>>1);
  digitalWrite(41,a%2); 
  a = (a>>1);
  digitalWrite(40,a%2);
  a = (a>>1);
  digitalWrite(39,a%2);
  a = (a>>1);
  digitalWrite(38,a%2);
  a = (a>>1);
  digitalWrite(37,a%2);  
  a = (a>>1);
  digitalWrite(36,a%2);
  a = (a>>1); 
  digitalWrite(35,a%2); 
  a = (a>>1);
  digitalWrite(34,a%2);
  a = (a>>1);
  digitalWrite(33,a%2);
  a = (a>>1);
  digitalWrite(32,a%2);
  a = (a>>1);
  digitalWrite(31,a%2);  
  a = (a>>1);
  digitalWrite(30,a%2);// MSB

  
  
  // OUTPUT
  /*
  set_io Xout[0] R10 // LSB
  set_io Xout[1] T11
  set_io Xout[2] T14
  set_io Xout[3] T15
  set_io Xout[4] T9 
  set_io Xout[5] T10
  set_io Xout[6] T13
  set_io Xout[7] R14
  */
  //delay(1);
  //Serial.println("Hi");
  z[7] = digitalRead(9); // MSB
  
  if(z[7] == 0)
  {
    z[6] = digitalRead(8);
    z[5] = digitalRead(7);
    z[4] = digitalRead(6);
    z[3] = digitalRead(5);
    z[2] = digitalRead(4);
    z[1] = digitalRead(3);
    z[0] = digitalRead(2); // LSB
    
    ANS = (z[7]<<7)+(z[6]<<6)+(z[5]<<5)+(z[4]<<4)+(z[3]<<3)+(z[2]<<2)+(z[1]<<1)+z[0];
      
    ans_sin = ANS/126.0;
    Serial.println(ans_sin + shift + error);
    //Serial.println(ANS);
  }
  else{
  //Serial.println(z3);
    z[7] = 0;
    z[6] = !digitalRead(8);
    z[5] = !digitalRead(7);
    z[4] = !digitalRead(6);
    z[3] = !digitalRead(5);
    z[2] = !digitalRead(4);
    z[1] = !digitalRead(3);
    z[0] = !digitalRead(2); // LSB
    c = 1;
    
    for(int j = 0; j < 8; j++) 
    {
      swap = z[j];
      z[j] = (swap + c)%2;
      c = (swap + c)/2;
    }
    ANS = (z[7]<<7)+(z[6]<<6)+(z[5]<<5)+(z[4]<<4)+(z[3]<<3)+(z[2]<<2)+(z[1]<<1)+z[0];
    ANS = ANS*(-1);
    ans_sin = ANS/124.0;
 
    //Serial.println("-OUTPUT-");
    Serial.println(ans_sin + shift + error);
    //Serial.println(ANS);
  }
  int dac_shift = 126 + ANS;
  for (int i = 22; i<30 ; i++) {
    digitalWrite(i,dac_shift%2); // start_LSB
    dac_shift = (dac_shift>>1);
  }
  delay(20);
// /}
if(i == 359)
  i = 0.0;
else i = i + 3;
}
