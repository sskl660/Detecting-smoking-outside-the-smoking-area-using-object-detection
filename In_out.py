# 사진을 실시간으로 가져오는 함수(1분 주기).
# 아래 주석중 영상 저장 경로에 5초마다 한장씩 사진이 저장되는 것을 활용하여 5초마다 디텍션 ㄱㄱ
# 함수 안에서 지속적으로 동작하는 구조이기 때문에 return 을 이용하여 값을 넘겨주기는 힘듦
# 그래서 시간대별로 텍스트 파일안에 이미지 이름을 라인별로 저장해두었다네
import cv2
import os
from os import listdir
from os.path import isfile, join
import define_area as define_area
import take_picture as tp
import custom_detection_person as per
import custom_detection_tobacco as tob
import custom_detection_total as tot
import custom_face_recognition
import pymysql
import ftplib
import os

def remove_all(path):
    if os.path.exists(path):
        for file in os.scandir(path):
            os.remove(file.path)
        return 'remove all'
    else:
        return 'directory not found'
def send_server(filename):
    ftp = ftplib.FTP()
    ftp.connect("25.59.203.122", 7000)
    ftp.login("img", "qkr21730")
    os.chdir(r"G:/capstone/ImageAI/detect/")
    myfile = open(filename, 'rb')
    ftp.storbinary('STOR ' + filename, myfile)
    myfile.close()
    ftp.close

def insert_mysql(date, id, addr):   #(날짜, 학번, 사진경로)
    conn = pymysql.connect(host='54.180.102.130', user='root', password='qkr21730',
                           db='sys', charset='utf8')

    try:
        with conn.cursor() as curs:
            sql = "insert into students(date, name, id, major, addr, mail, img) values(%s, %s, %s, %s, %s, %s, %s)"
            curs.execute(sql, (date, "", id, "", addr, "", ""))

            sql2 = """update students
                        set name=(select name from info where id=%s) , major=(select major from info where id=%s), 
                        mail = (select mail from info where id=%s), img=(select img from info where id=%s)
                        where id=%s and date=%s and addr=%s;"""

            curs.execute(sql2, (id, id, id, id, id, date, addr))

            sql3 = "update info set detectnum = detectnum + 1 where id=%s"
            curs.execute(sql3, id)

        conn.commit()

    finally:
        conn.close()

def isInside(x, y, poly):
    if [x, y] in poly:
        return True
    else:
        return False

def in_out(dir):
    if os.path.exists(dir):
        # 폴더 내 모든 파일의 이름을 순차적으로 저장함.
        files = [f for f in listdir("G:/capstone/ImageAI/take_picture/") if isfile(join("G:/capstone/ImageAI/take_picture/", f))]
        # files 에 저장된 파일 이름들을 순차적으로 불러옴.
        for filename in files:
            print("사람 탐지 중...")
            points = per.detection(filename)
            per_point = []
            for point in points:
                if isInside(point[4], point[5], poly):
                    pass
                else:
                    per_point.append(point)
            print("담배 탐지 중...")
            tob_point = []
            tob_point = tob.detection(filename)
            v_person = []
#            print("흡연구역을 벗어난 흡연자 탐지 중...")
            v_person = tot.in_out_tobacco(per_point, tob_point)
#            print("범위 밖 흡연자 탐지 완료")
            img = cv2.imread("G:/capstone/ImageAI/take_picture/" + filename, 1)
            for v in v_person:
                cv2.rectangle(img, (v[0], v[1]), (v[2], v[3]), (0, 0, 255))
            save_path = "G:/capstone/ImageAI/detect/" + filename
            cv2.imwrite(save_path, img)
            print("얼굴 인식 중...")
            for i in range(0, len(v_person)):
                face = img[v_person[i][1]:v_person[i][3], v_person[i][0]:v_person[i][2]]
                violator_path = "G:/capstone/ImageAI/violator/" + str(i) + '-' + filename
                cv2.imwrite(violator_path, face)
            crop = [v for v in listdir("G:/capstone/ImageAI/violator/") if isfile(join("G:/capstone/ImageAI/violator/", v))]
            for crop_jpg in crop:
                #face_recog_double = cv2.resize(crop_jpg, dsize = (0, 0), fx = 2, fy = 2, interpolation = cv2.INTER_LINEAR)
                face_recog = custom_face_recognition.face_recog()
                frame, name = face_recog.get_frame(crop_jpg)
                if name:
                    cv2.imwrite("G:/capstone/ImageAI/result/" + crop_jpg, frame)
                    cv2.destroyAllWindows()
                    date = '2020 - ' + filename[0:5]
                    print("적발자 신상정보 전송 중...")
                    insert_mysql(date, name, filename)
#                    print("데이터 전송 완료!")
                    os.remove("G:/capstone/ImageAI/result/" + crop_jpg)
                    os.remove("G:/capstone/ImageAI/violator/" + crop_jpg)
                    print("현장 적발 이미지 전송 중....")
                    send_server(filename)
#                    print("현장 적발 이미지 전송 완료!")
            # 작업이 완료된 파일 삭제


    # 파일 목록 초기화
    files = []
    #in_out(dir)


if __name__ == "__main__":
    video = 'G:/capstone/ImageAI/video/today.MOV'
    print("영역 설정 후 e 키를 누른 후 기다려주세요.")
    poly, edge, color = define_area.define_area(video)
    print("이미지 추출 중...")
    #tp.capture(video)
    print("detection을 실행합니다.")
    in_out("G:/capstone/ImageAI/take_picture")
#    print('take_picture ',remove_all("G:/capstone/ImageAI/take_picture"))
    print('in_out ', remove_all("G:/capstone/ImageAI/in_out/"))
    print('violator ', remove_all("G:/capstone/ImageAI/violator/"))
    print('result ', remove_all("G:/capstone/ImageAI/result/"))
    print('detect ', remove_all("G:/capstone/ImageAI/detect"))
    print("finish!")