# Correctable-Pronunciation
## Blues
 
언어 장애인(마비말환자)들의 부정확한 발음을 개선시켜 주는 애플리케이션  (김시영, 김민제, 차요셉)

This is application for dysarthria to improve their pronunciation by using deep learning
by Siyoung Kim, Minje Kim, Hyunah jang, Joseph cha

### 0. 개요
------------------------------
한국어 음성인식을 제공하는 kaldi toolkit을 사용하여 언어모델을 구현하고 실시간 음성인식을 가능하게 하여 음성인식 서버와 앱 연동을 진행한다.               
또한 음성인식률을 분석부를 추가하여 도표로도 구현, 사용자가 학습을 마친 후, 학습률과 일치율 확인이 가능하다.

<img src="/images/Zeroth.png" width="50%"><img src="/images/AppDesign.png" width="50%">


### 1. 제작 목적
------------------------------
언어 환자들 중 마비말환자는 70%정도를 차지한다.             
따라서 많은 환자들은 언어 치료를 위한 비용, 접근의 측면에서 어려움을 겪고 있다.                  
따라서 손쉬운 언어 치료 접근성, 딥러닝 기술을 사용한 각 환자에게 알맞는 연속적 데이터 학습을 하게 하여                       
환자 개인에게 맞는 솔루션 제공을 하고자 한다.              
이를 바탕으로 환자 개인의 언어 치료 부자재로써 어플리케이션을 개발하고자 한다. 

### 2. 역할 분담
------------------------------
 * 김시영 : 서버, DB, 언어, 발음 교육
 * 김민제 : ASR Model, 정확도 산출 알고리즘 
 * 차요셉 : 애플리케이션(iOS)

### 3. 참고
------------------------------
 * Kaldi github : https://github.com/kaldi-asr/kaldi
 * Zeroth project github : https://github.com/goodatlas/zeroth
 * Python Korean Handler : https://github.com/neotune/python-korean-handler
