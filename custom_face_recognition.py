import face_recognition
import cv2
import os
import numpy as np

class face_recog:
    def __init__(self):

        self.known_face_names = []
        self.known_face_encodings = []
        dirname = 'G:/capstone/ImageAI/knowns'
        files = os.listdir(dirname)
        for filename in files:
            name, ext = os.path.splitext(filename)
            if ext == '.jpg':
                self.known_face_names.append(name)
                pathname = os.path.join(dirname, filename)
                img = face_recognition.load_image_file(pathname)
                face_encoding = face_recognition.face_encodings(img)[0]
                self.known_face_encodings.append(face_encoding)

        self.face_locations = []
        self.face_encodings = []
        self.face_names = []
        self.process_this_frame = True

    def get_frame(self, file=""):
        self.file = 'G:/capstone/ImageAI/violator/' + file
        frame = face_recognition.load_image_file(self.file, mode = 'RGB')

        self.face_locations = face_recognition.face_locations(frame)
        self.face_encodings = face_recognition.face_encodings(frame, self.face_locations)

        for face_encoding in self.face_encodings:
            distances = face_recognition.face_distance(self.known_face_encodings, face_encoding)
            min_value = min(distances)

            name = 'Unknown'
            if min_value < 6.0:
                index = np.argmin(distances)
                name = self.known_face_names[index]
            self.face_names.append(name)

        for (top, right, bottom, left), name in zip(self.face_locations, self.face_names):
            top += 3
            right += 4
            bottom += 4
            left += 4

            cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

        return frame, self.face_names

# face_recog = face_recog(file = "1234.jpg")
# print(face_recog.known_face_names)
# frame, name = face_recog.get_frame()
# print(name)
# frame1 = cv2.resize(frame, dsize = (0, 0),  fx=0.25, fy=0.25, interpolation = cv2.INTER_AREA)
# cv2.imshow("Frame", frame1)
# key = cv2.waitKey(0)
# if key == ord("e"):
#     cv2.destroyAllWindows()
