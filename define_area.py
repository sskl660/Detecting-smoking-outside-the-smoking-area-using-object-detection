import cv2
import datetime
import numpy as np
import copy
from collections import deque


drawing = True  # True 라인을 그리는 상태.
color = [0, 0, 255]  # 색상 지정 : 기본값 = red
ix, iy = -1, -1
# 시작 좌표를 구하기 위한 전역 변수.
cnt = 0
st_ix, st_iy = -1, -1


# 마우스 콜백 함수
# x, y는 실시간으로 들어오는 마우스 좌표.
# ix, iy는 실시간으로 들어오는 마우스 좌표를 넘겨 전역 변수로 처리.
def draw_circle(event, x, y, flags, param):
    global ix, iy, drawing, mode, cnt
    global st_ix, st_iy

    if event == cv2.EVENT_LBUTTONDOWN:
        if drawing is True:
            cnt += 1
            if cnt == 1:
                st_ix = x
                st_iy = y
            if ix != -1 and iy != -1:
                temp_x = ix
                temp_y = iy
                ix, iy = x, y
                cv2.line(img, (temp_x, temp_y), (ix, iy), color, 1)
            else:
                ix, iy = x, y


# 범위 만들기(도형)
def make_poly(h, w):
    cnt = 0
    poly = []
    start_x, start_y = -1, -1
    for i in range(h):
        temp = []
        for j in range(w):
            if np.array_equal(img[i][j], color):
                poly.append([j, i])
                temp.append(j)
        if temp and cnt == 0:
            start = min(temp)
            end = max(temp)
            if end - start > 1:
                for k in range(len(temp) - 1):
                    if temp[k] + 1 < temp[k + 1]:
                        start_x, start_y = temp[k] + 1, i
                if ([start_x, start_y] in poly) or (start_x == -1 and start_y == -1):
                    pass
                else:
                    cnt += 1
        else:
            pass
    edge = []
    edge = copy.deepcopy(poly)
    poly = flood_fill(start_x, start_y, poly)

    return poly, edge


def flood_fill(x, y, poly):
    queue = deque()
    queue.append([x, y])
    while queue:
        x, y = queue.popleft()
        for nx, ny in (x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1):
            if np.array_equal(img[ny][nx], color):
                continue
            else:
                img[ny][nx] = color
                poly.append([nx, ny])
                queue.append((nx, ny))

    return poly


def define_area(init_picture):
    global img

    # 입력 비디오
    cap = cv2.VideoCapture(init_picture)

    # 동영상의 첫 프레임 캡처
    while True:
        if cap.grab():
            ret, frame = cap.read()
            # 수동 캡처 기능
            # cv2.imshow("VideoFrame", frame)

            now = datetime.datetime.now().strftime("%m-%d-%H-%M-%S")
#            key = cv2.waitKey(60)

            # 동영상 첫 부분(첫 프레임) "일_시-분-초" 형식으로 저장.
            if (int(cap.get(1)) % 20 == 0):
#                print('Saved frame number : ' + str(int(cap.get(1))))
                cv2.imwrite("G:/capstone/ImageAI/take_picture/" + str(now) + ".jpg", frame)
#                cv2.imwrite(str(now) + ".jpg", frame)
#                print("./take_picture/" + str(now) + ".jpg")
                filename = "G:/capstone/ImageAI/take_picture/" + str(now) + ".jpg"
#                filename = str(now) + ".jpg"
                break
            # 수동 캡처 기능
            # if key == ord("c"):
            #     print("캡쳐")
            #     cv2.imwrite(str(now) + ".png", frame)
            #     filename = str(now) + ".png"
            # if key == 27:
            #     break
        # 비디오 무한 재생
        # else:
        #     cap = cv2.VideoCapture('bb.mp4')


    # 내가 그리는 라인의 색(red)과 유사한 부분이 있으면 변환(전처리).
    img = cv2.imread(filename, 1)
    height, width, channel = img.shape[0], img.shape[1], img.shape[2]
    for i in range(height):
        for j in range(width):
            if np.array_equal(img[i][j], color):
                if color[2] + 1 == 256:
                    img[i][j] = [color[0], color[1], color[2] - 1]
                else:
                    img[i][j] = [color[0], color[1], color[2] + 1]
    cv2.namedWindow('image')
    cv2.setMouseCallback('image', draw_circle)


    # 라인 그리는 부분
    while True:
        cv2.imshow('image', img)
        k = cv2.waitKey(1) & 0xFF
        # e 키를 누르면 다각형을 완성하고 종료
        if k == ord('e'):
            cv2.line(img, (ix, iy), (st_ix, st_iy), color, 1)
            poly, edge = make_poly(height, width)
            drawing = False
            break
        elif k == 27:
            break

    cap.release()
    cv2.destroyAllWindows()

    return poly, edge, color