from imageai.Detection.Custom import CustomObjectDetection
import os

def detection(Image):
    name1 = "G:/capstone/ImageAI/take_picture/" + Image
    name2 = "G:/capstone/ImageAI/in_out/1" + Image
    foldername = 'smoker'
    execution_path = 'G:/capstone/ImageAI/' + foldername
    points = []
    count = 0
    detector = CustomObjectDetection()
    detector.setModelTypeAsYOLOv3()
    detector.setModelPath(os.path.join(execution_path, "models", "detection_model-ex-143--loss-0007.288.h5"))
    detector.setJsonPath(os.path.join(execution_path, "json", "detection_config.json"))
    detector.loadModel()
    detections = detector.detectObjectsFromImage(input_image = name1, output_image_path = name2)
    for detection in detections:
        #print(detection["name"], " : ", detection["percentage_probability"], " : ", detection["box_points"])
        #print("center : (", (detection["box_points"][0] + detection["box_points"][2]) / 2, ", ", detection["box_points"][3], ")")
        points.append([])
        for i in range (0, 4):
            points[count].append(detection["box_points"][i])
        count += 1
    return points
