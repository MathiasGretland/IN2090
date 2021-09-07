def twoSum(nums, target):
    """
    :type nums: List[int]
    :type target: int
    :rtype: List[int]
    """
    rtype = []
    start = 0
    lengden = len(nums)
    for tall in nums:
        if nums[tall] != nums[start]:
            maal = nums[tall] + nums[start]
            if maal == target:
                rtype.append(nums[start], nums[tall])
        else:
            start+1

    return rtype


nums = [2, 7, 11, 15]
target = 9
skrt = twoSum(nums, target)
