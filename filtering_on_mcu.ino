
float x[1000];
float y[1000]={0};
int N=1000;
int L= 8;

double t=0; //initializing time outside of 100p
const float Pi = 3.14159; //defining constant pi
int j=0; //will serve as counter to increment time
unsigned long time1; //for counting time since run beging
float f[]={0,0,0,0,0}; //to store 5 values of E
int i=4;
//used for indexing above array
float b[]={0,0,0,0,0}; //to store 5 values of result
float sensorValue;


int sensorPin = A0;    //pin number to use the ADC
int thesensorValue = 0;  //initialization of sensor variable, equivalent to EMA Y
float EMA_a = 0.3;    //initialization of EMA alpha
float EMA_S = 0;        //initialization of EMA S
float highpass_sig;

void setup() {
  // put your setup code here, to run once:
Serial.begin (9600) ;
}

void loop() {
  // put your main code here, to run repeatedly:
//moving average filter for high freq noise
for (int i=0;i<N; i++){
      x[i] = analogRead (A0) ;
      delay (10) ;}
      for (int i=0; i<N;i++){
          for (int j=i; j<i+L && j<N;j++){
          y[i] = y[i] + x[j];}
          y[i] = y[i]/L; 
      }
          // for (int i= 0;i<N;i++){
          //Serial.print (x[i]+500);
         // Serial.print(",");
          //Serial.println(y[i]);
          // }
  
//Digital filter based on 4th Order Butterworth with cutoff wc=200pi rad/sec
  sensorValue = y[i];
j=j+1;
//time counter
t=0.001*j; //convert to ms
time1=micros(); //finding time since program started
f[i-4] = f[i-3]; f[i-3] = f[i-2];f[i-2] = f[i-1]; f[i-1] = f[i];//moves values of f up the array
f[i] = sensorValue; //current value of input function
b[i-4] = b[i-3]; b[i-3] = b[i-2]; b[i-2] = b[i-1]; b[i-1] = b[i]; //moves values of y up the array
b[i] = 2.42*b[i-1]-2.396*b[i-2]+1.105*b[i-3]-0.198*b[i-4]+0.004*f[i]+0.017*f[i-1]+0.026*f[i-2]+0.017*f[i-3]+0.004*f[i-4]; //recursive function used for filtering the signal

//highpass filter
       //read the sensor value using ADC
  EMA_S = (EMA_a*b[i]) + ((1-EMA_a)*EMA_S);  //run the EMA
  highpass_sig = b[i] - EMA_S;                   //calculate the high-pass signal
 
  Serial.println(highpass_sig);
  delay(20);                                //20ms delay
 
}






  
