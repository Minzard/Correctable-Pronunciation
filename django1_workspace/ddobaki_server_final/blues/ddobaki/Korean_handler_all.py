# -*- coding: utf-8 -*-
import re
import sys
"""
    초성 중성 종성 분리 하기
    유니코드 한글은 0xAC00 으로부터
    초성 19개, 중성21개, 종성28개로 이루어지고
    이들을 조합한 11,172개의 문자를 갖는다.
    
    한글코드의 값 = ((초성 * 21) + 중성) * 28 + 종성 + 0xAC00
    (0xAC00은 'ㄱ'의 코드값)
    
    따라서 다음과 같은 계산 식이 구해진다.
    유니코드 한글 문자 코드 값이 X일 때,
    
    초성 = ((X - 0xAC00) / 28) / 21
    중성 = ((X - 0xAC00) / 28) % 21
    종성 = (X - 0xAC00) % 28
    
    이 때 초성, 중성, 종성의 값은 각 소리 글자의 코드값이 아니라
    이들이 각각 몇 번째 문자인가를 나타내기 때문에 다음과 같이 다시 처리한다.
    
    초성문자코드 = 초성 + 0x1100 //('ㄱ')
    중성문자코드 = 중성 + 0x1161 // ('ㅏ')
    종성문자코드 = 종성 + 0x11A8 - 1 // (종성이 없는 경우가 있으므로 1을 뺌)
    """
# 유니코드 한글 시작 : 44032, 끝 : 55199
BASE_CODE, CHOSUNG, JUNGSUNG = 44032, 588, 28

# 초성 리스트. 00 ~ 18
CHOSUNG_LIST = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']

# 중성 리스트. 00 ~ 20
JUNGSUNG_LIST = ['ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ']

# 종성 리스트. 00 ~ 27 + 1(1개 없음)
JONGSUNG_LIST = [' ', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']
def divide(test_keyword):
    split_keyword_list = list(test_keyword)
    #print(split_keyword_list)
    
    result = list()
    for keyword in split_keyword_list:
        # 한글 여부 check 후 분리
        if re.match('.*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*', keyword) is not None:
            char_code = ord(keyword) - BASE_CODE
            if char_code < 0 :
                result.append(keyword)
            else :
                char1 = int(char_code / CHOSUNG)
                result.append(CHOSUNG_LIST[char1])
                #print('초성 : {}'.format(CHOSUNG_LIST[char1]))
                char2 = int((char_code - (CHOSUNG * char1)) / JUNGSUNG)
                result.append(JUNGSUNG_LIST[char2])
                #print('중성 : {}'.format(JUNGSUNG_LIST[char2]))
                char3 = int((char_code - (CHOSUNG * char1) - (JUNGSUNG * char2)))
                if char3==0:
                    result.append(' ')
                else:
                    result.append(JONGSUNG_LIST[char3])
                #print('종성 : {}'.format(JONGSUNG_LIST[char3]))
        else:
            result.append(keyword)

    result = ''.join(result)
    return result

def compare_string(label_list, stt_list) :
    
    # label = dict(zip(range(len(label)), label))
    # stt = dict(zip(range(len(stt)), stt))
    # label_list = [['ㅁ', 'ㅏ', 'ㄴ'], ['ㅈ', 'ㅏ', ''], ['ㄹ', 'ㅡ', 'ㄴ']]
    # stt_list = [['ㅁ', 'ㅣ', 'ㄴ'], ['ㅈ', 'ㅏ', ''], ['ㄹ', 'ㅡ', '']]
    
    color_list = [['0' for _ in range(3)] for _ in range(len(stt_list))]
    num1 = 0
    num2 = 0
    color = ''
        
    for i in stt_list :
        for j in i :
            if j in label_list[num1] :
                color_list[num1][num2] = '1'
            num2 = num2 + 1
        num1 = num1 + 1
                                        
        if (num1 >= len(label_list)) :
            for i in range(len(label_list), len(stt_list)) :
                for j in range(0,3) :
                    color_list[i][j] = '0'
            break
                                                            
        num2 = 0
                                                                
    # print(color_list)
    
    color_list = sum(color_list, [])
    # print(color_list)
    for i in color_list :
        color = color + i
    # print(label_list)
    # print(stt_list)
    # print(color)
    return color

def convert(label, stt):
    split_label_list = list(label)
    split_stt_list = list(stt)
    #print(split_keyword_list)
    label_list = list()
    stt_list = list()
    
    for keyword in split_label_list:
        # 한글 여부 check 후 분리
        result = list()
        if re.match('.*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*', keyword) is not None:
            char_code = ord(keyword) - BASE_CODE
            char1 = int(char_code / CHOSUNG)
            result.append(CHOSUNG_LIST[char1])
            #print('초성 : {}'.format(CHOSUNG_LIST[char1]))
            char2 = int((char_code - (CHOSUNG * char1)) / JUNGSUNG)
            result.append(JUNGSUNG_LIST[char2])
            #print('중성 : {}'.format(JUNGSUNG_LIST[char2]))
            char3 = int((char_code - (CHOSUNG * char1) - (JUNGSUNG * char2)))
            if char3==0:
                result.append(' ')
            else:
                result.append(JONGSUNG_LIST[char3])
        #print('종성 : {}'.format(JONGSUNG_LIST[char3]))
        else:
            result.append(keyword)

        label_list.append(result)
                    
    for keyword in split_stt_list:
        # 한글 여부 check 후 분리
        result = list()
        if re.match('.*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*', keyword) is not None:
            char_code = ord(keyword) - BASE_CODE
            if char_code < 0 :
                result.append(keyword)
            else :
                char1 = int(char_code / CHOSUNG)
                result.append(CHOSUNG_LIST[char1])
                #print('초성 : {}'.format(CHOSUNG_LIST[char1]))
                char2 = int((char_code - (CHOSUNG * char1)) / JUNGSUNG)
                result.append(JUNGSUNG_LIST[char2])
                #print('중성 : {}'.format(JUNGSUNG_LIST[char2]))
                char3 = int((char_code - (CHOSUNG * char1) - (JUNGSUNG * char2)))
                if char3==0:
                    result.append(' ')
                else:
                    result.append(JONGSUNG_LIST[char3])
        #print('종성 : {}'.format(JONGSUNG_LIST[char3]))
        else:
            result.append(keyword)

        stt_list.append(result)

    color = compare_string(label_list, stt_list)
    return color

def get_accuracy(label_list, stt_list):
    color_list = [['0' for _ in range(3)] for _ in range(len(stt_list))]
    num1 = 0
    num2 = 0
        
    for i in stt_list :
        for j in i :
            if j in label_list[num1] :
                color_list[num1][num2] = '1'
            num2 = num2 + 1
        num1 = num1 + 1
                                        
        if (num1 >= len(label_list)) :
            for i in range(len(label_list), len(stt_list)) :
                for j in range(0,3) :
                    color_list[i][j] = '0'
            break
                                                            
        num2 = 0
                                                                
    # print(color_list)
    
    color_list = sum(color_list, [])
    accuracy_num = 0

    for i in color_list :
        if i=='1' :
            accuracy_num = accuracy_num + 1;

    accuracy = int((accuracy_num / len(color_list)) * 100)
    
    return accuracy

def accuracy(label, stt):
    split_label_list = list(label)
    split_stt_list = list(stt)
    #print(split_keyword_list)
    label_list = list()
    stt_list = list()
    
    for keyword in split_label_list:
        # 한글 여부 check 후 분리
        result = list()
        if re.match('.*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*', keyword) is not None:
            char_code = ord(keyword) - BASE_CODE
            char1 = int(char_code / CHOSUNG)
            result.append(CHOSUNG_LIST[char1])
            #print('초성 : {}'.format(CHOSUNG_LIST[char1]))
            char2 = int((char_code - (CHOSUNG * char1)) / JUNGSUNG)
            result.append(JUNGSUNG_LIST[char2])
            #print('중성 : {}'.format(JUNGSUNG_LIST[char2]))
            char3 = int((char_code - (CHOSUNG * char1) - (JUNGSUNG * char2)))
            if char3==0:
                result.append(' ')
            else:
                result.append(JONGSUNG_LIST[char3])
        #print('종성 : {}'.format(JONGSUNG_LIST[char3]))
        else:
            result.append(keyword)

        label_list.append(result)
                    
    for keyword in split_stt_list:
        # 한글 여부 check 후 분리
        result = list()
        if re.match('.*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*', keyword) is not None:
            char_code = ord(keyword) - BASE_CODE
            if char_code < 0 :
                result.append(keyword)
            else :
                char1 = int(char_code / CHOSUNG)
                result.append(CHOSUNG_LIST[char1])
                #print('초성 : {}'.format(CHOSUNG_LIST[char1]))
                char2 = int((char_code - (CHOSUNG * char1)) / JUNGSUNG)
                result.append(JUNGSUNG_LIST[char2])
                #print('중성 : {}'.format(JUNGSUNG_LIST[char2]))
                char3 = int((char_code - (CHOSUNG * char1) - (JUNGSUNG * char2)))
                if char3==0:
                    result.append(' ')
                else:
                    result.append(JONGSUNG_LIST[char3])
        #print('종성 : {}'.format(JONGSUNG_LIST[char3]))
        else:
            result.append(keyword)

        stt_list.append(result)

    accuracy = get_accuracy(label_list, stt_list)
    return accuracy
