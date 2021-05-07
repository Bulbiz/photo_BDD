#! /usr/bin/env python3

from faker import Faker
from datetime import datetime
import random

Faker.seed(0)

fake = Faker('fr_FR')


def generate_photographer(min, max):
    for i in range(min, max):
        name = fake.name().split()
        print(','.join([
            str(i), name[0], ' '.join(name[1:]), '0' + ''.join(
                random.sample(
                    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
                    9))
        ]))


# pid, change_date, print_price, digital_price
def generate_pricehistory():
    with open("./generated-csv/photography.csv", "r") as photo_file:
        for entry in photo_file:
            attr = entry.split(',')
            for i in range(random.randint(0, 10)):
                print(','.join([
                    attr[0],
                    format(
                        fake.date_time_between(start_date='-30y',
                                               end_date='-1y')),
                    str(random.randint(1, 5000)),
                    str(random.randint(1, 10000))
                ]))

            print(','.join([
                attr[0],
                format(fake.date_time_between(start_date='-1y',
                                              end_date='now')), attr[4],
                attr[5]
            ]))


def generate_photographycopy():
    with open("./generated-csv/photography.csv", "r") as photo_file:
        i = 0
        for entry in photo_file:
            i += 1
            attr = entry.split(',')
            print(','.join([
                str(i), attr[0], "1",
                random.sample(["JPEG", "PNG", "RAW"], 1)[0], "", "true", "", ""
            ]))
            for j in range(random.randint(0, 10)):
                i += 1
                is_in_stock = random.sample([True, False], 1)[0]
                print(','.join([
                    str(i), attr[0], "0", "",
                    (str(random.randint(10, 10000)) + "x" +
                     str(random.randint(10, 10000))),
                    "true" if is_in_stock else "false",
                    format(
                        fake.date_time_between(start_date="now",
                                               end_date="+1y"))
                    if not is_in_stock else "",
                    str(random.randint(1, 1000) if is_in_stock else 0)
                ]))


copies = [
    copy.split(',')
    for copy in open("./generated-csv/photographycopy.csv", "r")
]


def get_available_copy(used_copies):
    i = random.randint(0, len(copies) - 1)
    while True:
        copy = copies[i]
        if copy[0] not in used_copies and copy[5] == "true":
            return copy
        i = (i + 1) % len(copies)


def generate_shoppingcartelem_and_command():
    selem = open("./generated-csv/shoppingcartelem.csv", "w")
    cmd = open("./generated-csv/command.csv", "w")
    copy_id = 0
    cmd_id = 0
    for client in open("./generated-csv/client.csv", "r"):
        copy_id += 1
        cmd_id += 1
        should_print_cmd = True
        cmd_date = fake.date_time_between(start_date='-1m', end_date='now')
        shipping_date = fake.date_time_between_dates(
            datetime_start=cmd_date, datetime_end=datetime.now())
        client = client.split(',')
        used_copies = []
        for j in range(random.randint(0, 15)):
            copy = get_available_copy(used_copies)
            used_copies.append(copy)
            quantity = random.randint(1,
                                      100 if copy[2] == '1' else int(copy[7]))
            status = random.randint(-1, 4)
            if status == -1:
                selem.write(','.join([
                    str(copy_id), client[0], copy[0],
                    str(quantity), "",
                    str(status), "", ""
                ]))
                selem.write("\n")
            elif status == 0 or status == 1:
                selem.write(','.join([
                    str(copy_id), client[0], copy[0],
                    str(quantity),
                    str(cmd_id),
                    str(status), "", ""
                ]))
                selem.write("\n")
                if should_print_cmd:
                    cmd.write(','.join([
                        str(cmd_id), client[0],
                        format(
                            fake.date_time_between(start_date='-1m',
                                                   end_date='now')),
                        str(random.randint(1, 500)),
                        str(random.randint(1, 500)), "true" if random.sample(
                            [True, False], 1)[0] else "false", "true"
                        if random.sample([True, False], 1)[0] else "false"
                    ]))
                    cmd.write("\n")
            elif status == 2:
                cmd_date = fake.date_time_between(start_date='-1m',
                                                  end_date='now')
                selem.write(','.join([
                    str(copy_id), client[0], copy[0],
                    str(quantity),
                    str(cmd_id),
                    str(status),
                    format(
                        fake.date_time_between_dates(
                            datetime_start=cmd_date,
                            datetime_end=datetime.now())), ""
                ]))
                selem.write("\n")
                if should_print_cmd:
                    cmd.write(','.join([
                        str(cmd_id), client[0],
                        format(cmd_date),
                        str(random.randint(1, 500)),
                        str(random.randint(1, 500)), "true" if random.sample(
                            [True, False], 1)[0] else "false", "true"
                        if random.sample([True, False], 1)[0] else "false"
                    ]))
                    cmd.write("\n")
            else:
                selem.write(','.join([
                    str(copy_id), client[0], copy[0],
                    str(quantity),
                    str(cmd_id),
                    str(status),
                    format(shipping_date),
                    format(
                        fake.date_time_between_dates(
                            datetime_start=shipping_date,
                            datetime_end=datetime.now()))
                ]))
                selem.write("\n")
                if should_print_cmd:
                    cmd.write(','.join([
                        str(cmd_id), client[0],
                        format(cmd_date),
                        str(random.randint(1, 500)),
                        str(random.randint(1, 500)), "true" if random.sample(
                            [True, False], 1)[0] else "false", "true"
                        if random.sample([True, False], 1)[0] else "false"
                    ]))
                    cmd.write("\n")

            copy_id += 1
            if status != -1:
                new_cmd_id = cmd_id + random.sample([0, 0, 0, 0, 1], 1)[0]
                if new_cmd_id != cmd_id:
                    cmd_id = new_cmd_id
                    should_print_cmd = True
                    cmd_date = fake.date_time_between(start_date='-1m',
                                                      end_date='now')
                    shipping_date = fake.date_time_between_dates(
                        datetime_start=cmd_date, datetime_end=datetime.now())
                else:
                    should_print_cmd = False


def generate_reviews():
    for elem in open("./generated-csv/shoppingcartelem.csv", "r"):
        elem = elem.split(',')
        if elem[5] in ['3', '4'] and 1 == random.randint(0, 3):
            print(','.join([
                elem[1], elem[2],
                str(random.randint(0, 10)),
                fake.text(max_nb_chars=80),
                format(fake.date_time_between(start_date='-1y',
                                              end_date='now'))
            ]))


def generate_return():
    for elem in open("./generated-csv/shoppingcartelem.csv", "r"):
        elem = elem.split(',')
        if elem[5] in ['4']:
            print(','.join([
                elem[0],
                elem[4],
                format(fake.date_time_between(start_date='-1y',
                                              end_date='now')),
                fake.text(max_nb_chars=80),
            ]))


generate_return()
