def in_out_tobacco(per_point, tob_point):
    violation_person = []
    for person in per_point:
        for tobacco in tob_point:
            tobacco_cen_x = (tobacco[0] + tobacco[2])/2
            tobacco_cen_y = (tobacco[1] + tobacco[3])/2
            if (person[0] < tobacco_cen_x < person[2]) and (person[1] < tobacco_cen_y < person[3]):
                if person in violation_person:
                    continue
                violation_person.append(person)
                continue

    return violation_person

