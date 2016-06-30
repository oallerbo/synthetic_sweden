import pandas as pd
from collections import Counter
import os
import datetime
import sys
import matplotlib.pyplot as plt

def map_purpose(purpose):
  if purpose == 1:
    return 'home'
  if purpose == 2:
    return 'work'
  if purpose == 3: #shopping
    return 'shopping'
  if purpose == 4:
    return 'other'
  if purpose == 5:
    return 'school'
  if purpose == 6:
    return 'college'
  return 'other'

def format_time(sec):
  time_string = str(datetime.timedelta(seconds=sec))[:-3]
  if len(time_string) == 4:
    time_string = '0' + time_string
  return time_string

try:
  acts_w_got_locs_df = pd.read_csv('../data/acts_w_got_locs.csv')
except:
  #Get all locations
  home_locs_df = pd.read_csv('../VT/sweden_home_locs_v3.txt', delimiter=r'\s+')[['#id', 'x', 'y', 'zone']]
  other_locs_df = pd.read_csv('../VT/sweden_locations_v3.txt', delimiter=r'\s+')[['#id', 'x', 'y', 'zone']]
  locs_df = home_locs_df.append(other_locs_df, ignore_index=True)

  #Get locations outside Gothenburg
  ngot_locs_df = locs_df[locs_df['zone'] != 20298983]
  ngot_locs_ids = set(ngot_locs_df['#id'].values.tolist())

  #Get persons doing things outside Gothenburg
  acts_df = pd.read_csv('../VT/sweden_activities_v3.txt', delimiter=r'\s+')[['pid', 'purpose', 'starttime', 'duration', 'location']]
  ngot_acts_df = acts_df[acts_df['location'].isin(ngot_locs_ids)]
  ngot_acts_pids = set(ngot_acts_df['pid'].values.tolist())

  #Remove activities outside Gothenburg
  got_acts_df = acts_df[~acts_df['pid'].isin(ngot_acts_pids)]

  #Get persons in Gothenburg that are at home some time and
  #Remove persons that are never at home
  got_home_acts_df = got_acts_df[got_acts_df['purpose'] == 1]
  got_home_pids = set(got_home_acts_df['pid'].values.tolist())
  got_acts_df = got_acts_df[got_acts_df['pid'].isin(got_home_pids)]

  #Remove persons that do not travel
  pids = (got_acts_df['pid'].values.tolist())
  count_pids = Counter(pids)
  keep_pids = set()
  for pid in count_pids:
    if count_pids[pid] > 1:
      keep_pids.add(pid)
  got_acts_df = got_acts_df[got_acts_df['pid'].isin(keep_pids)]

  acts_w_got_locs_df = pd.merge(got_acts_df, locs_df, left_on='location', right_on='#id', how='left')
  acts_w_got_locs_df.to_csv('../data/acts_w_got_locs.csv', index=False)

acts_w_got_locs_df = acts_w_got_locs_df[acts_w_got_locs_df['pid'] < 5654400] # min('pid') == 5654328
print 'csv file read.'
print 'Legs: {0}'.format(len(acts_w_got_locs_df.index))

xml_lines = ['<?xml version="1.0" ?>\n', '<!DOCTYPE plans SYSTEM "http://www.matsim.org/files/dtd/plans_v4.dtd">\n', '<plans>\n', 'dummy1\n', 'dummy2\n']
old_pid = 0
first = True
for index, row in acts_w_got_locs_df.iterrows():
  pid = int(row['pid'])
  if pid != old_pid:
    xml_lines = xml_lines[:-2] #remove the last leg
    xml_lines += ['\t</plan>\n', '</person>\n', '\n'] #close previous person
    if first:
      xml_lines = xml_lines[:-3] #remove closing if first person
      first = False
    xml_lines += ['<person id="' + str(pid) + '">\n', '\t<plan>\n']
    time_string = 'end_time="' + format_time(int(row['starttime']) + int(row['duration']))
  else:
    time_string = 'dur="' + format_time(int(row['duration']))

  act_line = ['\t\t<act type="' + map_purpose(int(row['purpose'])) + '" x="' + str(row['x']) + '" y="' + str(row['y']) + '" ' + time_string + '" />\n']
  leg_lines = ['\t\t<leg mode="car">\n', '\t\t</leg>\n']
  xml_lines += act_line + leg_lines

  old_pid = pid

xml_lines = xml_lines[:-2] #remove the last leg
xml_lines += ['\t</plan>\n', '</person>\n', '\n'] #close previous person
xml_lines += ['</plans>\n'] #close plans

f = open('../data/plans.xml', 'w')
f.writelines(xml_lines)
f.close()

## Old things

#  #Get home locations in Gothenburg
#  home_locs_df = pd.read_csv('../sweden_home_locs_v3.txt', delimiter=r'\s+')[['#id', 'x', 'y', 'zone']]
#  got_home_locs_df = home_locs_df[home_locs_df['zone'] == 20298983]
#  got_hloc_ids = set(got_home_locs_df['#id'].values.tolist())
#
#  #Convert location ids to household ids
#  hh_df = pd.read_csv('../sweden_household_v3.txt', delimiter=r'\s+')[['hid', 'hloc']]
#  got_hh_df = hh_df[hh_df['hloc'].isin(got_hloc_ids)]
#  got_hh_ids = set(got_hh_df['hid'].values.tolist())
#
#  #Get activities for households in gothenburg
#  acts_df = pd.read_csv('../sweden_activities_v3.txt', delimiter=r'\s+')[['#hid', 'pid', 'anum', 'purpose', 'starttime', 'duration', 'location']]
#  got_acts_df = acts_df[acts_df['#hid'].isin(got_hh_ids)]
#  got_acts_df.to_csv('got_acts.csv', index=False)
#
#  #Locations for other activities than home
#  other_locs_df = pd.read_csv('../sweden_locations_v3.txt', delimiter=r'\s+')[['#id', 'x', 'y', 'zone']]
#
#  locs_df = got_home_locs_df.append(other_locs_df, ignore_index=True)
#
#
#  #print len(home_locs_df.index)
#  #print len(other_locs_df.index)
#  #print len(locs_df.index)
#  #print len(got_locs_df.index)
#  acts_w_got_locs_df = pd.merge(got_acts_df, locs_df, left_on='location', right_on='#id', how='left')
#  acts_w_got_locs_df.to_csv('acts_w_got_locs.csv', index=False)


#f.write('<?xml version="1.0" ?>\n<!DOCTYPE plans SYSTEM "http://www.matsim.org/files/dtd/plans_v4.dtd">\n<plans>\n')
#old_pid = 0
#first = True
#for index, row in acts_w_locs_df.iterrows():
#  pid = int(row['pid'])
#  if pid != old_pid:
#    if not first:
#      f.write('\t</plan>\n</person>\n\n')
#    first = False
#    f.write('<person id="' + str(pid) + '">\n\t<plan>\n')
#
#  f.write('\t\t<act type="' + str(int(row['purpose'])) + '" x="' + str(row['x']) + '" y="' + str(row['y']) + '" end_time="' + str(int(row['starttime'])) + '" />\n')
#  f.write('\t\t<leg mode="car">\n\t\t</leg>\n')
#
#  old_pid = pid
#
#f.write('\t</plan>\n</person>\n\n</plans>')
#f.close()
