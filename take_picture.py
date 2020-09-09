import cv2
import datetime


def capture(filename):
    cap = cv2.VideoCapture(filename)
    msec = []
    point = []
    # 동영상 주기적으로 캡처
    while True:
        if cap.grab():
            ret, frame = cap.read()
            if not ret:
                cv2.destroyAllWindows()
                break
                # cap = cv2.VideoCapture("bb8.mp4")
                # continue
            cv2.imshow("VideoFrame", frame)
            now = datetime.datetime.now().strftime("%m-%d-%H-%M-%S")
            key = cv2.waitKey(60)
            minute = datetime.datetime.now().strftime("%M")
            sec = datetime.datetime.now().strftime("%S")
            msec.append(datetime.datetime.now().strftime("%f"))

            # 5초 마다 동영상 첫 부분(첫 프레임) "일_시-분-초" 형식으로 저장.
            if int(sec) % 10 == 0:
                if len(msec) == 1:
#                    print('Saved frame number : ' + str(int(cap.get(1))))
                    # 영상 저장 경로!
                    cv2.imwrite("G:/capstone/ImageAI/take_picture/" + str(now) + ".jpg", frame)
#                    print("./take_picture/" + str(now) + ".jpg")

            if len(msec) == 15:
                msec = []
        else:
            cv2.destroyAllWindows()
            break
        # else:
        #     cap = cv2.VideoCapture("bb.mp4")